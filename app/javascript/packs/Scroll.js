export default () => {
  $(document).ready(function(){
    const smoothScroll = new SmoothScroll('a[href^="#"]', {
      offset: 10,
    })

    if(window.location.hash) {
      const anchor = document.querySelector(window.location.hash);
      if (anchor) {
         smoothScroll.animateScroll(anchor, undefined, { offset: 40 });
      }
    }
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
