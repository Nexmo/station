import urllib
import urllib2
import json

base_url = 'https://api.nexmo.com'
version = '/v1'
action = '/applications/?'

#Create an Application for Voice API.
params = {
        'api_key': 'API_KEY',
        'api_secret': 'API_SECRET',
        'name' : 'MyFirstApplication',
        'type' : 'voice',
        'answer_url' : 'https://nexmo-community.github.io/ncco-examples/conference.json',
        'event_url' : 'https://example.com/call_status'
}
#In this example, answer_url points to a static NCCO that creates a Conference.

url =  base_url + version + action
data =  urllib.urlencode(params)

request = urllib2.Request(url, data)
request.add_header('Accept', 'application/json')

try:
    response = urllib2.urlopen(request)
    data = response.read()
    if response.code == 201:
        application = json.loads(data.decode('utf-8'))
        print "Application " + application['name'] + " has an ID of:" + application['id']
        for webhook in application['voice']['webhooks'] :
                print "  " + webhook['endpoint_type'] + " is " + webhook['endpoint']
        print "  You use your private key to connect to Nexmo endpoints:"
        print "  " + application['keys']['private_key']
    else:
        print "HTTP Response: " + response.code
        print data

except urllib2.HTTPError as e:
    print e
