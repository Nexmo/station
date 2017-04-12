export default class TabbedExamples {
  constructor() {
    this.restoreTabs = this.restoreTabs.bind(this);
    this.setupEvents = this.setupEvents.bind(this);
    this.onTabClick = this.onTabClick.bind(this);
    this.persistLanguage = this.persistLanguage.bind(this);
    this.restoreTabs();
    this.setupEvents();
  }

  restoreTabs() {
    if (window.localStorage) {
      var language = window.localStorage.getItem('languagePreference', language);
      if (language) { return this.setLanguage(language); }
    }
  }

  setupEvents() {
    return $('.tabs--code li').click(this.onTabClick);
  }

  onTabClick(event) {
    let language = $(event.currentTarget).data('language');
    if (language) {
      this.setLanguage(language);
      return this.persistLanguage(language);
    }
  }

  persistLanguage(language) {
    if (language && window.localStorage) {
      return window.localStorage.setItem('languagePreference', language);
    }
  }

  setLanguage(language) {
    return $(`.tabs--code [data-language='${language}'] a`).each(function() {
      let tabs = $(this).parents('.tabs');
      let tab = $(this).parent();

      return $(tabs).foundation('_handleTabChange', tab, true);
    });
  }
};
