$(document).on('input', '#search', function(event) {
  fetch('/quicksearch?query=' + $(event.target).val())
  .then(function(response) {
    return response.text()
  })
  .then(function(body) {
    $('#search-results').html(body)
    $('#search-results').toggle(body != '')
  })
});
