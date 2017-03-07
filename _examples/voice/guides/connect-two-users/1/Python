import json
import requests
from datetime import datetime
import calendar
from jose import jwt
import requests
from application_generate_jwt import generate_jwt
import ConfigParser
from <my jwt helper functions> import generate_jwt

#Set the endpoint
base_url = "https://api.nexmo.com"
version = "/v1"
action = "/calls"

#Application and call information
application_id = "id-for-your-voice-application"
keyfile = "application_secret_key.txt"
#Create your JWT
jwt = generate_jwt(application_id, keyfile)

#Create the headers using the jwt
headers = {
    "Content-type": "application/json",
    "Authorization": "Bearer {0}".format(jwt)
}

#Change the to parameter to the number you want to call
payload = {
    "to":[{
        "type": "phone",
        "number": "441632960961"
    }],
    "from": {
        "type": "phone",
        "number": "441632960977"
    },
    "answer_url": ["https://www.example.com/call_sales.json"]
}

response = requests.post( base_url + version + action , data=json.dumps(payload), headers=headers)

if (response.status_code == 201):
    print response.content
else:
    print( "Error: " + str(response.status_code) + " " +    response.content)
