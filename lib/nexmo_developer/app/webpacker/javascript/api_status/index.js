import 'whatwg-fetch'

export default () => {
  fetch('https://k4cdqxp909c5.statuspage.io/api/v2/status.json')
  .then((response) => response.json())
  .then((payload) => {
  	var color;
  	switch (payload.status.indicator) {
  		case 'major':
  			color = 'red';
  		case 'critical':
  			color = 'red';
  		case 'minor':
  			color = 'yellow';
  		default:
  			color = 'green';
  	}
    $('.Nxd-api-status').text(payload.status.description).addClass(`Vlt-badge--` + color)
  })
}
