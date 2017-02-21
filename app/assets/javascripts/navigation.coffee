window.navigationAnimationInProgress = false
animationSpeed = 0.2

init = (animate = false)->
  $('.js-navigation > li > ul').each ->
    height = $(this).height()
    $(this).data 'height', height
    if $(this).find('.active').length == 0
      TweenLite.set $(this), { height: 0 }
    else
      TweenLite.fromTo $(this), animationSpeed, { height: 0 }, { height: height } if animate
      $(this).addClass 'expanded'
      $(this).find('a.active').first().closest('.js--collapsible').siblings().find('ul').hide()

  $('.js-navigation > li').click((event) ->
    if $(event.target).parents('.expanded').length == 0
      window.animateNavigationOnLoadIn = true
      window.navigationAnimationInProgress = true
      TweenLite.to $('.js-navigation .expanded'), animationSpeed, { height: 0, onComplete: navigationAnimationComplete }
    else
      window.animateNavigationOnLoadIn = false
    true
  )

  $('.js-navigation > a').click ->
    TweenLite.to $('.js-navigation .expanded'), animationSpeed, { height: 0, onComplete: navigationAnimationComplete }

injectFutureNavigation = ->
  if window.futureNavigation && !window.navigationAnimationInProgress
    $('.js-navigation').html window.futureNavigation
    window.futureNavigation = undefined
    init(window.animateNavigationOnLoadIn)

navigationAnimationComplete = ->
  window.navigationAnimationInProgress = false
  injectFutureNavigation()

$(document).ready ->
  init()

$(document).on 'turbolinks:before-render', (event) ->
  window.futureNavigation = $(event.originalEvent.data.newBody).find('.js-navigation').html()

$(document).on 'turbolinks:load', ->
  injectFutureNavigation()
