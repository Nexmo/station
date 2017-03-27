document.addEventListener 'turbolinks:visit', ->
  window.contentAnimationInProgress = true
  TweenLite.fromTo($('#primary-content'), 0.2, { alpha: 1 }, {
    alpha: 0,
    onComplete: contentAnimationComplete,
  });

contentAnimationComplete = ->
  window.contentAnimationInProgress = false
  injectFutureContent()

injectFutureContent = ->
  if window.futureContent && !window.contentAnimationInProgress
    $('#primary-content').html window.futureContent
    window.futureContent = undefined
    TweenLite.fromTo($('#primary-content'), 0.3, { alpha: 0 }, { alpha: 1 });

$(document).on 'turbolinks:before-render', (event) ->
  window.futureContent = $(event.originalEvent.data.newBody).find('#primary-content').html()

$(document).on 'turbolinks:load', ->
  injectFutureContent()
  $(document).trigger 'nexmo:load'
