export default () => {
  $(document).on('click', '.js-collapsible', function() {
    const id = $(this).data('collapsible-id')
    $(this).parent('.collapsible').toggleClass('collapsible--active')
    $(`#${id}`).toggle()
  })
}
