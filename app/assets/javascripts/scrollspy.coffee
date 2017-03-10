startScroll = 125

onScroll = ->
  currentPosition = $(document).scrollTop()
  delta = currentPosition + 20

  $activeHeading = undefined

  if currentPosition > startScroll
    $('.sidenav > ul').css({
      'width': $('.sidenav').width(),
      'top': 20,
    })

    $('.sidenav > ul').css('position', 'fixed')
  else
    $('.sidenav > ul').css({
      'width': 'auto',
      'position': 'relative',
      'top': 0,
    })

  $('#primary-content').find('h1,h2,h3,h4,h5,h6').each ->
    $heading = $(@)
    headingOffset = $heading.offset().top

    return false if headingOffset > delta
    $activeHeading = $heading


  if $activeHeading && $activeHeading.length > 0
    id = $activeHeading.attr('id')
    $nextHeading = $(".js-scrollspy a[href='##{id}']")

    if $nextHeading.length > 0
      $(".js-scrollspy .active").removeClass('active')
      $nextHeading.addClass('active')

$(document).ready ->
  # onScrollThrottled = _.throttle(onScroll, 20);
  onScrollThrottled = onScroll
  $(document).scroll(onScrollThrottled)
