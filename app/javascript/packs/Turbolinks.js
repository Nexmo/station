export function preventSamePage() {
  $(document).on('turbolinks:click', function(event) {
    if (event.target.getAttribute('href').charAt(0) === '#') {
      event.preventDefault();
    }

    if (event.target.getAttribute('href') === window.location.pathname) {
      return event.preventDefault();
    }
  });
}

export function animate() {
  document.addEventListener('turbolinks:visit', () => {
    window.contentAnimationInProgress = true;
    TweenLite.fromTo($('#primary-content'), 0.2, { alpha: 1 }, {
      alpha: 0,
      onComplete: contentAnimationComplete,
    });
  });

  var contentAnimationComplete = () => {
    window.contentAnimationInProgress = false;
    injectFutureContent();
  };

  var injectFutureContent = () => {
    if (window.futureContent && !window.contentAnimationInProgress) {
      $('#primary-content').html(window.futureContent);

      // reeset
      window.futureContent = undefined
      window.contentAnimationInProgress = true

      TweenLite.fromTo($('#primary-content'), 0.3, { alpha: 0 }, { alpha: 1 });
      $(document).trigger('nexmo:load');
    }
  };

  $(document).on('turbolinks:before-render', (event) => {
   window.futureContent = $(event.originalEvent.data.newBody).find('#primary-content').html()
  });

  $(document).on('turbolinks:load', () => injectFutureContent());
}
