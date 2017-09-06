export default () => {
  $(document).ready(function() {
    $("input:radio[name='feedback_feedback[sentiment]']").change(function () {
      var sentiment = $(this).val()

      $('#extendedFields').toggle(sentiment === 'negative')
      $('#positiveFeedback').toggle(sentiment === 'positive')
      $(this).submit()
    })

    $(".new_feedback_feedback input[type=submit]").click(function () {
      $("#basicFields, #extendedFields").hide()
      $("#postFeedback").show()
    })

    $('#positiveFeedback a').click(function (event) {
      event.preventDefault()
      $('#extendedFields').show()
      $('#positiveFeedback').hide()
    })
  })
}
