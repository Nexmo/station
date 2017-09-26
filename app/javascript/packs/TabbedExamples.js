import { Tabs } from 'foundation-sites/js/foundation.tabs'

export default class TabbedExamples {
  constructor() {
    if ($('[data-tabs]')[0]) {
      $('[data-tabs]').each(function(index, element) {
        new Tabs($(element))
      })

      this.restoreTabs = this.restoreTabs.bind(this)
      this.setInitialState = this.setInitialState.bind(this)
      this.setupEvents = this.setupEvents.bind(this)
      this.onTabClick = this.onTabClick.bind(this)
      this.onPopState = this.onPopState.bind(this)
      this.persistLanguage = this.persistLanguage.bind(this)
      this.restoreTabs()
      this.setInitialState()
      this.setupEvents()

      // Reset so that the language is read as normal instead of the data
      // attribute when the page loads in next time.
      $('#primary-content').data('initial-language', false)
    }
  }

  initialLanguage() {
    const initialLanguage = $('#primary-content').attr('data-initial-language')
    return initialLanguage === '' ? false : initialLanguage
  }

  shouldRestoreTabs() {
    const initialLanguage = this.initialLanguage()

    if (initialLanguage) {
      // Continue to restore the tab as if it were a normal page load if an
      // initialLanguage (url) is set but the tab does not exist
      return !this.doesTabLanguageExist(initialLanguage)
    }

    // Normal page load: Try to restore the tab.
    return true
  }

  doesTabLanguageExist(language) {
    return $(this.context).find(`[data-language='${language}']`).length > 0
  }

  restoreTabs() {
    $('[data-tabs]').each((index, element) => {
      this.context = element
      if (this.shouldRestoreTabs()) {
        if (window.localStorage) {
          var language = window.localStorage.getItem('languagePreference')
          $('#feedback_feedback_code_language').val(language)
          if (language) { this.setLanguage(language, this.context) }
        }

        if (window.localStorage) {
          var secondaryLanguage = window.localStorage.getItem('secondaryLanguagePreference')
          if (secondaryLanguage) { this.setLanguage(secondaryLanguage, this.context) }
        }
      }
    })
  }

  setInitialState() {
    const initialLanguage = this.initialLanguage()
    if (initialLanguage) {
      this.persistLanguage(initialLanguage, true)
    }
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
    const linkable = $(event.currentTarget).data('language-linkable')

    if (language) {
      this.setLanguage(language)

      if (linkable) {
        $('#feedback_feedback_code_language').val(language)
        $('#feedback_feedback_code_language_selected_whilst_on_page').prop('checked', true)

        if (window.history.state.language || this.initialLanguage()) {
          window.history.pushState({ language }, 'language', language)
        } else {
          let path = window.location.pathname.replace(/\/$/, '')
          window.history.pushState({ language }, 'language', `${path}/${language}`)
        }
      }

      this.persistLanguage(language, linkable)
    }
  }

  persistLanguage(language, linkable) {
    if (language && window.localStorage) {
      if (linkable) {
        window.localStorage.setItem('languagePreference', language)
      } else {
        window.localStorage.setItem('secondaryLanguagePreference', language)
      }
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
