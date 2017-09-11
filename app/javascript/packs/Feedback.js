export default () => {
  $(document).ready(function() {
    $("input:radio[name='feedback_feedback[sentiment]']").change(function () {
      var sentiment = $(this).val()

      $('.feedback-extended-fields').toggle(sentiment === 'negative')
      $('.feedback-positive-feedback').toggle(sentiment === 'positive')
      $(this).submit()
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
