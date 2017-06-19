export default () => {
  $(document).ready(function(){
    smoothScroll.init({
      selector: 'a[href^="#"]',
      offset: 10,
    })
  })

  $(document).on('click', 'a[href^="#"]', function(event) {
    const scrollspyId = $(event.currentTarget).data('scrollspy-id')
    if (scrollspyId) {
      $elm = $('[data-id="' + scrollspyId + '"]')
      smoothScroll.animateScroll($elm[0])
      event.preventDefault()
    }
  })
}
