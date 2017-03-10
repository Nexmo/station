$(document).ready(function(){
  smoothScroll.init({
    selector: 'a[href^="#"]',
    offset: 10,
  });
});

$(document).on('click', 'a[href^="#"]', function(event) {
  scrollspyId = $(event.currentTarget).data('scrollspy-id');
  if (scrollspyId) {
    $elm = $('[data-id="' + scrollspyId + '"]')
    console.log($elm[0]);
    smoothScroll.animateScroll($elm[0]);
    event.preventDefault();
  }
})
