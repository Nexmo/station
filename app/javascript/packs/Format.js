export default class Format {
  constructor() {
    const formatSelector = $('.js-format-selector')[0]
    if (formatSelector) {
      this.formatChanged(formatSelector.value)
      $(formatSelector).change((event) => this.formatChanged(event.target.value))
    }
  }

  formatChanged(format) {
    console.log('Setting format', format);
    $('.js-format').hide()
    $(`.js-format[data-format='${format}']`).show()
  }
}
