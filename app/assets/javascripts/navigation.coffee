$(document).ready ->
  $('nav > ul > li > ul').each ->
    $(this).data 'height', $(this).height()
    if $(this).find('.active').length == 0
      TweenLite.set $(this), { height: 0 }
    else
      $(this).addClass 'expanded'

  $('nav > ul > li').click ->
    TweenLite.to $('nav .expanded'), 0.2, { height: 0 }
    $('nav .expanded').removeClass 'expanded'
    $(this).children('ul').each ->
      height = $(this).data 'height'
      TweenLite.to $(this), 0.2, { height: height }
      $(this).addClass('expanded')

$(document).on 'turbolinks:load', ->
  $('nav .active').removeClass 'active'
  $('nav a').each ->
    if $(this).attr('href') == window.location.pathname
      $(this).addClass 'active'
