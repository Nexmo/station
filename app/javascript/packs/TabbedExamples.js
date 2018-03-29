import { Tabs } from 'foundation-sites/js/foundation.tabs'
import UserPreference from './UserPreference'

export default class TabbedExamples {
  constructor() {
    this.userPreference = new UserPreference

    if ($('[data-tabs]')[0]) {
      $('[data-tabs]').each(function(index, element) {
        new Tabs($(element))
      })

      this.restoreTabs = this.restoreTabs.bind(this)
      this.setupEvents = this.setupEvents.bind(this)
      this.onTabClick = this.onTabClick.bind(this)
      this.onPopState = this.onPopState.bind(this)
      this.persistLanguage = this.persistLanguage.bind(this)
      this.restoreTabs()
      this.setupEvents()
    }
  }

  shouldRestoreTabs(element) {
    return !$(element).data('has-initial-tab')
  }

  doesTabLanguageExist(language) {
    return $(this.context).find(`[data-language='${language}']`).length > 0
  }

  languages() {
    return $(this.context).find(`[data-language]`).map(function(index, el) {
      return $(el).data('language')
    })
  }

  restoreTabs() {
    $('[data-tabs]').each((index, element) => {
      this.context = element
      if (this.shouldRestoreTabs(element)) {
        const language = this.userPreference.topMatch(this.languages())
        if (language) { this.setLanguage(language, this.context) }
      }
    })
  }

  setupEvents() {
    $('.tabs li').click(this.onTabClick)
    $(window).on('popstate', this.onPopState)
  }

  onPopState(event) {
    if (window.history.state && window.history.state.language) {
      this.setLanguage(window.history.state.language)
    }
  }

  onTabClick(event) {
    const language = $(event.currentTarget).data('language')
    const languageType = $(event.currentTarget).data('language-type')
    const linkable = $(event.currentTarget).data('language-linkable')

    if (language) {
      this.setLanguage(language)

      if (linkable) {
        $(document).trigger('codeLanguageChange', { language })

        const rootPath = $('body').data('push-state-root')
        window.history.pushState({ language }, 'language', `${rootPath}/${language}`)
      }

      this.persistLanguage(language, languageType, linkable)
    }
  }

  persistLanguage(language, languageType, linkable) {
    if (language) {
      this.userPreference.promote(languageType, language)
    }
  }

  setLanguage(language, context = '.tabs') {
    $(context).find(`[data-language='${language}'] a`).each(function() {
      let tabs = $(this).parents('.tabs')
      let tab = $(this).parent()

      new Tabs(tabs)._handleTabChange(tab, true)
    })
  }
}
