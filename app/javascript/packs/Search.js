const icons = {
  'messaging / sms': 'fa-comments-o',
  'messaging / conversion-api': 'fa-reply',
  'messaging / sns': 'fa-bullhorn',
  'messaging / us-short-codes': 'fa-comments-o',
  'voice': 'fa-microphone',
  'verify': 'fa-key',
  'number-insight': 'fa-eye',
  'developer': 'fa-code',
  'account': 'fa-user-circle-o',
  'concepts': 'fa-globe',
}

export default () => {
  const algoliaApplicationId = $('meta[name=algoia_application_id]').attr('content')
  const algoliaPublishableKey = $('meta[name=algoia_publishable_key]').attr('content')

  const algolia = algoliasearch(algoliaApplicationId, algoliaPublishableKey);
  const helpIndex = algolia.initIndex('zendesk_nexmo_articles');
  const ndpIndex = algolia.initIndex('development_nexmo_developer');

  autocomplete('#search', { hint: false }, [
    {
      source: autocomplete.sources.hits(helpIndex, { hitsPerPage: 5 }),
      displayKey: 'title',
      templates: {
        header: '<div class="aa-suggestions-category">Knowledgebase</div>',
        suggestion: function(suggestion) {
          var template =  `<span class="aa-suggestion-product">${suggestion.section.full_path}</span>`
          template += `<a href="https://help.nexmo.com/hc/en-us/articles/${suggestion.id}">${suggestion._highlightResult.title.value}</a>`
          return template
        }
      }
    },
    {
      source: autocomplete.sources.hits(ndpIndex, { hitsPerPage: 5 }),
      displayKey: 'title',
      templates: {
        header: '<div class="aa-suggestions-category">Nexmo Developer</div>',
        suggestion: function(suggestion) {
          var template =  `<span class="aa-suggestion-product"><i class='fa ${icons[suggestion.product]}'></i> ${suggestion.product}</span>`
          template +=  `<a href="${suggestion.path}">${suggestion._highlightResult.title.value}</a>`
          if (suggestion.description) {
            template += `<small>${suggestion._highlightResult.description.value}</small></div>`
          }
          return template
        }
      }
    }
  ]);
}
