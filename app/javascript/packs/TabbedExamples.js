export default class TabbedExamples {
  constructor() {
    this.restoreTabs = this.restoreTabs.bind(this)
    this.setInitialState = this.setInitialState.bind(this)
    this.setupEvents = this.setupEvents.bind(this)
    this.onTabClick = this.onTabClick.bind(this)
    this.onPopState = this.onPopState.bind(this)
    this.persistLanguage = this.persistLanguage.bind(this)
    this.restoreTabs()
    this.setInitialState()
    this.setupEvents()
  }

  initialLanguage() {
    const initialLanguage = $('#primary-content').data('initial-language')
    return initialLanguage === '' ? false : initialLanguage
  }

  restoreTabs() {
    if (!this.initialLanguage()) {
      if (window.localStorage) {
        var language = window.localStorage.getItem('languagePreference')
        if (language) { this.setLanguage(language) }
      }
    }

    if (window.localStorage) {
      var secondaryLanguage = window.localStorage.getItem('secondaryLanguagePreference')
      if (secondaryLanguage) { this.setLanguage(secondaryLanguage) }
    }
  }

  setInitialState() {
    const initialLanguage = this.initialLanguage()
    if (initialLanguage) {
      window.history.pushState({ language: initialLanguage }, 'language', initialLanguage)
    }
  }

  setupEvents() {
    $('.tabs li').click(this.onTabClick)
    $(window).on('popstate', this.onPopState)
  }

  onPopState(event) {
    if (window.history.state.language) {
      this.setLanguage(window.history.state.language);
    }
  }

  onTabClick(event) {
    const language = $(event.currentTarget).data('language')
    const linkable = $(event.currentTarget).data('language-linkable')

    if (language) {
      this.setLanguage(language)

      if (linkable) {
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

  setLanguage(language) {
    $(`.tabs [data-language='${language}'] a`).each(function() {
      let tabs = $(this).parents('.tabs')
      let tab = $(this).parent()

      $(tabs).foundation('_handleTabChange', tab, true)
    })
  }
}
