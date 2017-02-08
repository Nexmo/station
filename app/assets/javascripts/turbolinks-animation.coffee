document.addEventListener 'turbolinks:render', (event) ->
  TweenLite.fromTo($('#primary-content'), 0.1, { alpha: 0 }, { alpha: 1 });

document.addEventListener 'turbolinks:visit', ->
  window.transitioning = true
  TweenLite.fromTo($('#primary-content'), 0.1, { alpha: 1 }, { alpha: 0 });
