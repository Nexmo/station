export default () => {
  $(document).ready(function() {
    window.invisibleCaptchaCallback = function(token) {
      window.userPassedInvisibleCaptcha = true
      $('#g-recaptcha-response').val(token).submit()
    }

    $("input:radio[name='feedback_feedback[sentiment]']").change(function () {
      var sentiment = $(this).val()

      $('.feedback-extended-fields').toggle(sentiment === 'negative')
      $('.feedback-positive-feedback').toggle(sentiment === 'positive')

      if ($('.g-recaptcha').length == 0 || window.userPassedInvisibleCaptcha) {
        $(this).submit()
      } else {
        grecaptcha.execute()
      }
    })

    $(".new_feedback_feedback input[type=submit]").click(function () {
      $(".feedback-basic-fields, .feedback-extended-fields").hide()
      $(".feedback-post-feedback").show()
    })

    $('.feedback-positive-feedback a').click(function (event) {
      event.preventDefault()
      event.stopPropagation()
      $('.feedback-extended-fields').show()
      $('.feedback-positive-feedback').hide()
    })
  })
}
