export default class Format {
  constructor() {
    this.platformSelector = $('.js-platform-selector')[0]
    if (this.platformSelector) {
      this.platformChanged(this.platformSelector.value, false)
      $(this.platformSelector).change((event) => this.platformChanged(event.target.value))
      this.restoreFormat()
    }
  }

  platformChanged(platform, persist = true) {
    console.log('Setting platform', platform);
    $('.js-platform').hide()
    $(`.js-platform[data-platform='${platform}']`).show()

    if (persist) {
      this.persistFormat(platform)
    }
  }

  persistFormat(platform) {
    if (window.localStorage) {
      window.localStorage.setItem('platform', platform)
    }
  }

  restoreFormat() {
    const platform = this.getParameter('platform')

    if (platform) {
      $(this.platformSelector).val(platform)
      this.platformChanged(platform, false)
    } else if (window.localStorage) {
      const platform = window.localStorage.getItem('platform')
      if (platform) {
        $(this.platformSelector).val(platform)
        this.platformChanged(platform, false)
      }
    }
  }

  getParameter(parameter) {
    if (window.URLSearchParams) {
      return new URLSearchParams(window.location.search).get(parameter)
    }
  }
}
