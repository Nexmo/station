window.TabbedExamples = class TabbedExamples
  constructor: () ->
    @restoreTabs()
    @setupEvents()

  restoreTabs: =>
    if window.localStorage
      language = window.localStorage.getItem('languagePreference', language)
      @setLanguage(language) if language

  setupEvents: =>
    $('.tabs--code li').click @onTabClick

  onTabClick: (event) =>
    language = $(event.currentTarget).data('language')
    if language
      @setLanguage(language)
      @persistLanguage(language)

  persistLanguage: (language) =>
    if language && window.localStorage
      window.localStorage.setItem('languagePreference', language)

  setLanguage: (language) ->
    $(".tabs--code [data-language='#{language}'] a").each ->
      @.click()
