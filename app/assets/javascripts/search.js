var search = function (event) {
  console.log('search');
  fetch('/quicksearch?query=' + $(event.target).val())
  .then(function(response) {
    return response.text()
  })
  .then(function(body) {
    $('#search-results').html(body)
    $('#search-results').toggle(body != '')
  })
}

$(document).ready(function(){
  $(document).on('input', '#search', _.debounce(search, 250));
});
