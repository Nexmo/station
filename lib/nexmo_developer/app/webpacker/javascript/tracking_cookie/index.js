export default class TrackingCookie {
  constructor() {
    this.setupListeners();
  }

  setupListeners() {
    window.addEventListener('load', function() {
      const dataset = document.getElementById('campaign').dataset;
      const campaign = dataset.campaign;
      const signupURL = dataset.signupUrl;

      fetch(signupURL, {
        method: 'POST',
        credentials: 'include',
        mode: 'cors',
        headers: { 'Content-Type': 'application/json', 'Origin': document.location.host },
        body: JSON.stringify({ 'utm_campaign': campaign }),
      })
      .then(data => { console.log('success'); })
      .catch((error) => { console.log('error setting dashboard cookie'); });
    });
  }
}
