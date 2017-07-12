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
        var language = window.localStorage.getItem('languagePreference', language)
        if (language) { this.setLanguage(language) }
      }
    }
  }

  setInitialState() {
    const initialLanguage = this.initialLanguage()
    if (initialLanguage) {
      window.history.pushState({ language: initialLanguage }, 'language', initialLanguage)
    }
  }

  setupEvents() {
    $('.tabs--code li').click(this.onTabClick)
    $(window).on('popstate', this.onPopState)
  }

  onPopState(event) {
    console.log('onPopState');
    if (window.history.state.language) {
      this.setLanguage(window.history.state.language);
    }
  }

  onTabClick(event) {
    const language = $(event.currentTarget).data('language')
    if (language) {
      this.setLanguage(language)

      if (window.history.state.language || this.initialLanguage()) {
        window.history.pushState({ language }, 'language', language)
      } else {
        let path = window.location.pathname.replace(/\/$/, '')
        window.history.pushState({ language }, 'language', `${path}/${language}`)
      }

      this.persistLanguage(language)
    }
  }

  persistLanguage(language) {
    if (language && window.localStorage) {
      window.localStorage.setItem('languagePreference', language)
    }
  }

  setLanguage(language) {
    return $(`.tabs--code [data-language='${language}'] a`).each(function() {
      let tabs = $(this).parents('.tabs')
      let tab = $(this).parent()

      return $(tabs).foundation('_handleTabChange', tab, true)
    })
  }
}
