let startScroll = 125;

let onScrollOrResize = function() {
  let currentPosition = $(document).scrollTop();
  let delta = currentPosition + 20;

  let $activeHeading = undefined;

  if (currentPosition > startScroll) {
    $('.sidenav > ul').css({
      'width': $('.sidenav').width(),
      'top': 20,
    });

    $('.sidenav > ul').css('position', 'fixed');
  } else {
    $('.sidenav > ul').css({
      'width': 'auto',
      'position': 'relative',
      'top': 0,
    });
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
    let onScrollOrResizeThrottled = _.throttle(onScrollOrResize, 20);
    $(document).scroll(onScrollOrResizeThrottled);
    return $(document).resize(onScrollOrResizeThrottled);
  });
}
