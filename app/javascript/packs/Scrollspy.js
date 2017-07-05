import throttle from 'lodash/throttle'

let onScrollOrResize = function() {
  let currentPosition = $(document).scrollTop();
  let delta = currentPosition + 20;

  $('.sidenav > ul').css({
    'width': 'auto',
    'position': 'relative',
    'top': 0,
  })
  .removeClass('navigation--fixed');

  if ($(".js-scrollspy, .js-navigation").length === 0) {
    return
  }

  let startScroll = $(".js-scrollspy, .js-navigation").offset().top - 20;

  let $activeHeading = undefined;

  if (currentPosition > startScroll) {
    $('.sidenav > ul').css({
      'width': $('.sidenav').width(),
    })
    .addClass('navigation--fixed');

    $('.sidenav > ul').css('position', 'fixed');
  }

  $('#primary-content').find('h1,h2,h3,h4,h5,h6').each(function() {
    let $heading = $(this);
    let headingOffset = $heading.offset().top;

    if (headingOffset > delta) { return false; }
    return $activeHeading = $heading;
  });


  if ($activeHeading && ($activeHeading.length > 0)) {
    let scrollSpyId = $activeHeading.data('id');
    let $nextHeading = $(`.js-scrollspy a[data-scrollspy-id='${scrollSpyId}']`);

    if ($nextHeading.length === 0) {
      let id = $activeHeading.attr('id');
      $nextHeading = $(`.js-scrollspy a[href='#${id}']`);
    }

    if ($nextHeading.length > 0) {
      $(".js-scrollspy .active").removeClass('active');
      return $nextHeading.addClass('active');
    }
  }
};

export default () => {
  $(document).ready(function() {
    let onScrollOrResizeThrottled = throttle(onScrollOrResize, 20);
    $(document).scroll(onScrollOrResizeThrottled);
    return $(document).resize(onScrollOrResizeThrottled);
  });
}
