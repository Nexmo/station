onScroll = ->
  currentPosition = $(document).scrollTop()
  delta = currentPosition + 20

  $activeHeading = undefined

  $('#primary-content').find('h1,h2,h3,h4,h5,h6').each ->
    $heading = $(@)
    headingOffset = $heading.offset().top

    return false if headingOffset > delta
    $activeHeading = $heading

  $(".js-scrollspy .active").removeClass('active')

  if $activeHeading && $activeHeading.length > 0
    id = $activeHeading.attr('id')
    $(".js-scrollspy a[href='##{id}']").addClass('active')

$(document).ready ->
  onScrollThrottled = _.throttle(onScroll, 20);
  $(document).scroll(onScrollThrottled)
