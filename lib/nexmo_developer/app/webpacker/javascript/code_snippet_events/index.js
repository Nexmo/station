export default () => {
  document.querySelectorAll('.code-toolbar button').forEach(function(button) {
    button.addEventListener('click', createRequest, { once: true })
  });
};

function createRequest(event) {
  let dataset = event.target.closest('.code-toolbar').firstChild.dataset;

  let params = {
    "language": dataset.lang,
    "snippet": dataset.block,
    "section": dataset.section,
    "event": "copy"
  };

  fetch(new Request('/usage/code_snippet', {
    method: 'POST',
    credentials: 'same-origin',
    body: JSON.stringify(params),
    headers: {
      'Content-Type': 'application/json'
    }
  }));
}
