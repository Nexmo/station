export default class TrackingCookie {
  constructor() {
    this.setupListeners();
  }

  setupListeners() {
    window.addEventListener('load', function() {
      const campaign = document.getElementById('campaign').dataset.campaign;

      fetch('https://signup.nexmo.com', {
        method: 'POST',
        mode: 'cors',
        headers: { 'Content-Type': 'application/json', 'Origin': document.location.host },
        body: JSON.stringify({ 'utm_campaign': campaign }),
      })
      .then(data => { console.log('success'); })
      .catch((error) => { console.log('error setting dashboard cookie'); });
    });
  }
}
