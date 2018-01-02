export default class Format {
  constructor() {
    this.formatChanged($('.js-format-selector')[0].value)
    $('.js-format-selector').change((event) => this.formatChanged(event.target.value))
  }

  formatChanged(format) {
    console.log('Setting format', format);
    $('.js-format').hide()
    $(`.js-format[data-format='${format}']`).show()
  }
}
