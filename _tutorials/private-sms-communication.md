---
title: Private SMS communication
products: messaging/sms
description: This tutorial shows you how to faciliate SMS communication between two parties without revealing either one's real phone number to the other.
languages:
    - Node
---

# Private SMS communication

Sometimes you want two parties to exchange SMS without revealing their actual phone numbers. 

For example, if you are operating a taxi booking service, then you want your customers and drivers to be able to communicate to coordinate pick-up times, locations, etc. But you don't want your driver to know your customer's phone number, so that you can protect their privacy. And, conversely, you don't want your customer to know the driver's number and be able to book taxi services directly, bypassing your application.

## In this tutorial

This tutorial is based on the [private SMS use case](https://www.nexmo.com/use-cases/private-sms-communication). It teaches you how to build an SMS proxy system using Node.js and the Nexmo Node.js REST API client library, using virtual phone numbers instead of real ones to enable two users to communicate anonymously.

To build the application, you perform the following steps:

* [Create the basic web application](#create-the-basic-web-application) - build the basic application framework
* [Configure the application](#configure-the-application) - to use your API key and secret and the virtual numbers you have provisioned
* [Create a conversation](#create-a-conversation) - create a mapping between your users' real and virtual numbers
* [Receive inbound SMS](#receive-inbound-sms) - capture incoming SMS on your virtual numbers and forward them to the target user's real number

## Prerequisites

To complete this tutorial, you need:

* A [Nexmo account](https://dashboard.nexmo.com/sign-up) - for your API key and secret and to rent virtual numbers.
* Two [Nexmo virtual numbers](https://developer.nexmo.com/concepts/guides/glossary#virtual-number) - to hide each user's real phone number from the other user. You can rent these in the [developer dashboard](https://dashboard.nexmo.com/buy-numbers).
* The [source code](https://github.com/Nexmo/node-sms-proxy) on GitHub - installation instructions are in the [README](https://github.com/Nexmo/node-sms-proxy/blob/master/README.md).
* [Node.js](https://nodejs.org/en/download/) installed and configured.
* [ngrok](https://ngrok.com/) - (optional) to make your development web server accessible to Nexmo's servers over the Internet.

## Create the basic web application

This application uses the [Express](https://expressjs.com/) framework for routing and the [Nexmo Node.js REST API client library](https://github.com/Nexmo/nexmo-node) for sending and receiving SMS. We use `dotenv` so that we can configure the application in a simple `.env` text file.

In `server.js` we initialize the application's dependencies and start the web server. We provide a route handler for the application's home page (`/`) so that you can test that the server is running by visiting `http://localhost:3000`:

```javascript
const express = require('express');
const bodyParser = require('body-parser');
const SmsProxy = require('./SmsProxy');

const app = express();
app.set('port', (process.env.PORT || 3000));
app.use(bodyParser.urlencoded({ extended: false }));

app.listen(app.get('port'), function () {
    console.log('SMS Proxy App listening on port', app.get('port'));
});

const config = require('dotenv').config();

const smsProxy = new SmsProxy(config.parsed);

app.get('/', (req, res) => {
    res.send('Hello world');
})
```

Note that we are instantiating an object of the `SmsProxy` class to handle the mapping of virtual numbers to real ones. We cover the actual proxying process in [proxy the SMS](#proxy-the-sms), but for now just be aware that this class initializes the `nexmo` REST API client library using the API key and secret that you will configure in the next step. This enables your application to send and receive SMS:

```javascript
const Nexmo = require('nexmo');

class SmsProxy {

    /**
     * Create a new SmsProxy
     */
    constructor(config) {

        this.config = config;

        this.nexmo = new Nexmo({
            apiKey: this.config.NEXMO_API_KEY,
            apiSecret: this.config.NEXMO_API_SECRET
        }, {
                debug: true
            });
    }
    ...
```

## Configure the application

Copy the `example.env` file provided to `.env` and modify it to include your Nexmo API key and secret and your Nexmo virtual numbers. You can find this information in the [developer dashboard](https://dashboard.nexmo.com):

```
NEXMO_API_KEY=YOUR_NEXMO_API_KEY
NEXMO_API_SECRET=YOUR_NEXMO_API_SECRET
VIRTUAL_NUMBER_A=YOUR_NEXMO_VIRTUAL_NUMBER
VIRTUAL_NUMBER_B=YOUR_OTHER_NEXMO_VIRTUAL_NUMBER
```

## Create a conversation

To use the application, you make a `POST` request to the `/conversation` route, passing in the real phone numbers of two users.

The route handler for `/conversation` is shown below:

```javascript
app.post('/conversation', (req, res) => {
    var userANumber = req.body.userANumber;
    var userBNumber = req.body.userBNumber;

    smsProxy.createConversation(userANumber, userBNumber, (err, result) => {
        if (err) {
            res.status(500).json(err);
        }
        else {
            res.json(result);
        }
    });

});
```

The conversation object is created in the `createConversation()` method of the `smsProxy` class. It stores information about each user's real and virtual phone numbers:

```javascript
    createConversation(userANumber, userBNumber) {
        this.conversation = {
            userA: {
                realNumber: userANumber,
                virtualNumber: this.config.VIRTUAL_NUMBER_A
            },
            userB: {
                realNumber: userBNumber,
                virtualNumber: this.config.VIRTUAL_NUMBER_B
            }
        };

        this.sendSMS();
    }
```

### Send a confirmation SMS

Now that we have created a conversation, we need to send each user a confirmation SMS from the virtual number of the other user.

> **Note**: In this tutorial each user receives the virtual number via an SMS. In production systems this could be supplied using email, in-app notifications or as a predefined number.

In the `sendSMS()` method of the `smsProxy` class we call the Nexmo REST API client library's `sendSms()` method twice to send a message to each user's real number, making it appear to be from their virtual number:

```javascript
    sendSMS() {
        // Send UserA conversation information
        // From the UserB virtual number
        // To the UserA real number
        console.log(this.conversation);

        this.nexmo.message.sendSms(this.conversation.userB.virtualNumber,
            this.conversation.userA.realNumber,
            'Reply to this SMS to talk to UserB');

        // Send UserB conversation information
        // From the UserA virtual number
        // To the UserB real number
        this.nexmo.message.sendSms(this.conversation.userA.virtualNumber,
            this.conversation.userB.realNumber,
            'Reply to this SMS to talk to UserA');
    }
```

## Receive inbound SMS
When one user sends a message to the other, they are sending it to their virtual, rather than real number. When Nexmo receives an inbound SMS on one of these virtual numbers it makes an HTTP request to the webhook endpoint associated with the virtual number:

In `server.js`, we provide a route handler for the `/webhooks/inbound-sms` `POST` request that Nexmo makes to your application when one of your virtual numbers receives an SMS. We retrieve the `to`, `from` and `text` from the inbound request, and pass it to the `SmsProxy` class to determine which real number to send it to:

```javascript
app.post('/webhooks/inbound-sms', (req, res) => {
    var from = req.body.msisdn;
    var to = req.body.to;
    var text = req.body.text;

    console.log(`from ${from} to ${to} - ${text}`)

    // Route virtual number to real number
    smsProxy.proxySms(from, to, text);

    res.sendStatus(200);
});
```

We return a `200` status to represent successful receipt of the message. This is an important step, because if we don't acknowedge receipt Nexmo's servers will make repeated attempts to deliver it.

### Determine how to route the SMS

Now that you know the real number of the user sending the SMS, you can work out which virtual number to send it to:

* If the `from` number is `UserA`'s real number, the `to` number is `UserB`'s virtual number
* If the `from` number is `UserB`'s real number, the `to` number is `UserA`'s virtual number

This logic is implemented in the `getProxyRoute()` method of the `SmsProxy` class:

```javascript
    getProxyRoute(from, to) {
        let proxyRoute = null;

            // Use to and from numbers to work out who is sending to whom
            const fromUserA = this.fromUserAToUserB(from, to, this.conversation);
            const fromUserB = this.fromUserBToUserA(from, to, this.conversation);

            if (fromUserA || fromUserB) {
                proxyRoute = {
                    to: fromUserA ? this.conversation.userB : this.conversation.userA,
                    from: fromUserA ? this.conversation.userA : this.conversation.userB
                };
            }
        
        return proxyRoute;
    }

    fromUserAToUserB(from, to, conversation) {
        return (from === this.conversation.userA.realNumber &&
            to === this.conversation.userB.virtualNumber);
    }

    fromUserBToUserA(from, to, conversation) {
        return (from === this.conversation.userB.realNumber &&
            to === this.conversation.userA.virtualNumber);
    }
```

Now all you have to do is proxy the SMS from the recipient's virtual number to their real number.

### Proxy the SMS

Proxy the SMS to the real phone number that the target virtual number is associated with. The `from` number is always the virtual number, the `to` is the user's real phone number.

```javascript
    proxySms(from, to, text) {
        // Determine how the SMS should be routed
        const proxyRoute = this.getProxyRoute(from, to);
        console.log(proxyRoute)

        if (proxyRoute === null) {
            const errorText = 'No conversation found' +
                ' from: ' + from +
                ' to: ' + to;
            throw new Error(errorText);
        }

        // Always send
        // - from the virtual number
        // - to the real number
        this.nexmo.message.sendSms(proxyRoute.from.virtualNumber,
            proxyRoute.to.realNumber, text);
    }
```

## Try it out

### Expose your application to the Internet

When the SMS API receives an SMS destined for one of your virtual numbers, it alerts your application via a [webhook](/concepts/guides/webhooks). The webhook provides a mechanism for Nexmo's servers to communicate with yours.

For your application to be accessible to Nexmo's servers, it must be publicly available on the Internet. A simple way to achieve this during development and testing is to use [ngrok](https://ngrok.com), a service that exposes local servers to the public Internet over secure tunnels. See [this blog post](https://www.nexmo.com/blog/2017/07/04/local-development-nexmo-ngrok-tunnel-dr/) for more details.

Download and install [ngrok](https://ngrok.com), then start it with the following command:

```sh
ngrok http 3000
```

This creates public URLs (HTTP and HTTPS) for any web site that is running on port 3000 on your local machine.

Use the `ngrok` web interface at <http://localhost:4040> and make a note of the URLs that `ngrok` provides. 

Go to your [account settings](https://dashboard.nexmo.com/settings) page and enter the full URL to your webhook endpoint in the "Inbound Messages" text box. For example, if you are using `ngrok` then your URL might resemble the following:

```
https://33ab96a2.ngrok.io/webhooks/inbound-sms
```



### Start the conversation

Make a `POST` request to your application's `/conversation` endpoint, passing in your users' real numbers as request parameters.

You could use [Postman](https://www.getpostman.com) for this, or a `curl` command similar to the following, replacing `USERA_REAL_NUMBER` and `USERB_REAL_NUMBER` with your users' actual numbers:

```sh
curl -X POST \
  'http://localhost:3000/conversation?userANumber=USERA_REAL_NUMBER&userBNumber=USERB_REAL_NUMBER' 
```

### Continue the conversation

Each user should receive a text from the other user's virtual number. When a user replies to that number it is delivered to the other user's real number, but appears to come from their virtual one.


## Conclusion

In this tutorial, you learned how to build an SMS proxy to enable two users to exchange SMS without either seeing the other's real number. 


## Where Next?

The following resources will help you find out more about what you learned in this tutorial:

* [Tutorial code on GitHub](https://github.com/Nexmo/node-sms-proxy)
* [Private SMS use case](https://www.nexmo.com/use-cases/private-sms-communication)
* [SMS API reference guide](/api/sms)
* [Other SMS API tutorials](/messaging/sms/tutorials)
* [Setting up and using Ngrok](https://www.nexmo.com/blog/2017/07/04/local-development-nexmo-ngrok-tunnel-dr/)
