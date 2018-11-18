---
title: Private SMS communication
products: messaging/sms
description: This tutorial shows you how to faciliate SMS communication between two parties without revealing either one's real phone number to the other.
languages:
    - Node
---

# Private SMS communication

You might want to enable two parties to exchange SMS without revealing their actual phone numbers. 

For example, if you are operating a taxi booking service, then you want your customers and drivers to be able to communicate to coordinate pick-up times, locations, etc. But you do not want your driver to know your customer's phone number, so that you can protect their privacy. And, conversely, you do not want your customer to know the driver's number and be able to book taxi services directly outside the context of your application.

This tutorial shows you how to build an SMS proxy system in Node.js which uses virtual phone numbers instead of real ones so that both parties' numbers are kept private.

## In this tutorial

In this tutorial you learn how to build an SMS proxy for private communication between two users using the following Nexmo APIs:

* **Numbers** - to search for, rent and provision virtual numbers
* **Number Insight** - to validate users' real numbers
* **SMS** - to send and receive SMS

To build the application, you perform the following steps:

* [Create the Project](#create-the-project) - build the basic application framework and expose it to the public internet so that Nexmo's APIs can inform your application about any inbound SMS
* [Acquire virtual numbers](#acquire-virtual-numbers) - use the Numbers API to rent the virtual numbers you will use to hide your users' real numbers
* [Initiate private SMS communication](#initiate-private-sms-communication) - use the Number Insight API to ensure that your users' real numbers are valid and create a mapping between their real and virtual numbers
* [Process inbound SMS](#process-inbound-sms) - receive inbound SMS on your virtual numbers and proxy it to the target user's real number

## Prerequisites

To complete this tutorial, you need:

* A [Nexmo account](https://dashboard.nexmo.com/sign-up) - for your API key and secret and to rent [Nexmo virtual numbers](https://developer.nexmo.com/concepts/guides/glossary#virtual-number)
* Node.js installed and configured - see [here](https://nodejs.org/en/download/)
* [ngrok](https://ngrok.com/) - (optional) to make your development web server accessible to Nexmo's servers over the Internet

## Create the project
Make a directory for your application, `cd` into the directory and then use the Node.js package manager `npm` to create a `package.json` file for your application's dependencies:

```sh
mkdir myapp
cd myapp
npm init
```

Press [Enter] to accept each of the defaults except `entry point` for which you should enter `server.js`.

Then, install the [express](https://expressjs.com) web application framework, the [body-parser](https://www.npmjs.com/package/body-parser) for `POST` requests and the [nexmo](https://github.com/Nexmo/nexmo-node) REST client library for Node.js packages:

```sh
npm install express body-parser nexmo --save
```

### Expose your application to the Internet

When the SMS API receives an SMS destined for one of your virtual numbers, it alerts your application via a [webhook](/concepts/guides/webhooks). The webhook provides a mechanism for Nexmo's servers to communicate with yours.

For your application to be accessible to Nexmo's servers, it must be publicly available on the Internet. A simple way to achieve this during development and testing is to use [ngrok](https://ngrok.com), a service that exposes local servers to the public Internet over secure tunnels. See [this blog post](https://www.nexmo.com/blog/2017/07/04/local-development-nexmo-ngrok-tunnel-dr/) for more details.

Download and install [ngrok](https://ngrok.com), then start it with the following command:

```sh
ngrok http 5000
```

This creates public URLs (HTTP and HTTPS) for any web site that is running on port 5000 on your local machine.

Use the `ngrok` web interface at <http://localhost:4040> and make a note of the URLs that `ngrok` provides: you need them to complete this tutorial.

### Create the basic application

1. Create a `server.js` file in your application directory with the following code, which will be our starting point:

    ```javascript
    const express = require('express');
    const bodyParser = require('body-parser');

    const app = express();
    app.set('port', (process.env.PORT || 5000));
    app.use(bodyParser.urlencoded({ extended: false }));

    app.listen(app.get('port'), () => {
        console.log('SMS Proxy App listening on port', app.get('port'));
    });
    ```

2. Execute the file in the terminal:

    ```sh
    node server.js
    ```

    If everything is working correctly, you should see the `SMS Proxy App listening on port 5000` message display in the console output.

    Now the basic server is in place you can focus on the SMS Proxy logic. You will use a class called `SmsProxy` for this.

3. Create a file called `SmsProxy.js` and enter the following code, replacing `NEXMO_API_KEY` and `NEXMO_API_SECRET` with your API key and secret from the [Nexmo account settings page](https://dashboard.nexmo.com/settings):

    ```javascript
    const Nexmo = require('nexmo');

    class SmsProxy {

        constructor() {
            this.nexmo = new Nexmo({
                apiKey: NEXMO_API_KEY,
                apiSecret: NEXMO_API_SECRET
            });

            // Virtual Numbers to be assigned to UserA and UserB
            this.provisionedNumbers = [];

            // In progress conversations
            this.conversations = [];
        }
    }

    module.exports = SmsProxy;
    ```

4. Instantiate the `SmsProxy` class in `server.js`:

    ```javascript
    const express = require('express');
    const bodyParser = require('body-parser');

    const app = express();
    app.set('port', 5000);
    app.use(bodyParser.urlencoded({ extended: false }));

    const SmsProxy = require('./SmsProxy');
    const smsProxy = new SmsProxy();

    app.listen(app.get('port'), () => {
        console.log('SMS Proxy App listening on port', app.get('port'));
    });
    ```

## Acquire virtual numbers

You will use virtual numbers in your application to hide your users' real numbers. Your application will enable you to provision these numbers dynamically.

> **Note**: In a production application you will probably choose from a pool of pre-provisioned virtual numbers.

This involves three steps:

* [Searching](#search-for-available-numbers) for available numbers in the right country, which are capable of sending and receiving SMS
* [Renting](#rent-virtual-numbers) (provisioning) those numbers
* [Configuring](#configure-the-virtual-numbers) the application to use the provisioned numbers

```js_sequence_diagram
Participant App
Participant Nexmo
Note over App,Nexmo: Initialization
App->Nexmo: Search Numbers
Nexmo-->App: Numbers Found
App->Nexmo: Provision Numbers
Nexmo-->App: Numbers Provisioned
App->Nexmo: Configure Numbers
Nexmo-->App: Numbers Configured
```

### Search for available numbers

To find suitable numbers, use the [Numbers API search capability](/api/developer/numbers#search-available-numbers), specifying the `country` (e.g. `GB`) and `features` (i.e. `SMS`) you require.

Add a method called `provisionVirtualNumbers()` to the `SmsProxy` class to perform this step:

```javascript
provisionVirtualNumbers() {
    // Buy a UK number with SMS capabilities.
    this.nexmo.number.search('GB', { features: 'SMS' }, (err, res) => {
        if (err) {
            console.error(err);
        }
        else {
            const numbers = res.numbers;

            // For demo purposes:
            // - Assume that at least two numbers will be available
            // - Rent just two virtual numbers: one for each conversation participant
            this.rentNumber(numbers[0]);
            this.rentNumber(numbers[1]);
        }
    });
}
```

The `provisionVirtualNumbers()` method finds the first two available numbers that meet your criteria and then calls `rentNumber()` on each. You code this method in the next step.

### Rent virtual numbers

Use the Numbers API again to [purchase the numbers](/api/developer/numbers#buy-a-number). Code the `rentNumber()` method as follows:

```javascript
rentNumber(number) {
    this.nexmo.number.buy(number.country, number.msisdn, (err, res) => {
        if (err) {
            console.error(err);
        }
        else {
            this.configureNumber(number);
        }
    });
}
```

If the `buy` operation is successful, you must then configure the numbers in your application.

### Configure the virtual numbers

You want Nexmo's servers to notify your application every time one of your virtual numbers receives an SMS. To do this, you need to provide a [webhook](/concepts/guides/webhooks).

Create the `configureNumber()` method in the `SmsProxy` class that uses the Numbers API to configure your account to receive these notifications.

In your application, the route for the inbound SMS webhook will be at `/inbound-sms`. If you are using Ngrok, the full webhook endpoint you need to configure resembles `https://demo.ngrok.io/inbound-sms`, where `demo` is the subdomain provided by Ngrok (typically something like `0547f2ad`).

Replace `SMS_WEBHOOK_URL` with your webhook endpoint. We will code the route for this webhook in a later step.

```javascript
configureNumber(number) {
    this.nexmo.number.update(number.country, number.msisdn, { moHttpUrl: 'SMS_WEBHOOK_URL' }, (err, res) => {
        console.log
        if (err) {
            console.error(err);
        }
        else if (!this.isProvisioned(number)) {
            this.provisionedNumbers.push(number);
        }
    });
}

isProvisioned(checkNumber) {
    this.provisionedNumbers.forEach((number) => {
        if (checkNumber.msisdn === number.msisdn) {
            return true;
        }
    });
    return false;
}
```

You have now purchased and configured two virtual numbers, one for each of your users.

## Initiate private SMS communication

The workflow when a conversation is created within the application is:

```js_sequence_diagram
Participant App
Participant Nexmo
Participant UserA
Participant UserB
Note over App,Nexmo: Conversation Starts
App->Nexmo: Basic Number Insight
Nexmo-->App: Number Insight response
App->App: Map Real/Virtual Numbers\nfor Each Participant
App->Nexmo: SMS to UserA
Nexmo->UserA: SMS
App->Nexmo: SMS to UserB
Nexmo->UserB: SMS
```

First check the numbers, then save the conversation and finally send an SMS notification to each conversation participant:

```js
createConversation(userANumber, userBNumber, cb) {
    this.checkNumbers(userANumber, userBNumber)
        .then(this.saveConversation.bind(this))
        .then(this.sendSMS.bind(this))
        .then((conversation) => {
            cb(null, conversation);
        })
        .catch((err) => {
            console.error(err);
            cb(err);
        });
}
```

### Validate numbers

When your application users supply their phone numbers use Number Insight to ensure that they are valid. The Number Insight response also [formats each number correctly](concepts/guides/glossary#number-format) for use in the other Nexmo APIs and tells you which country the number is registered in.

Create the `checkNumbers()` method in the `SmsProxy` class to perform these checks. The `checkNumbers()` method should return a `Promise` only when it has successfully validated both numbers:

```javascript
checkNumbers(userANumber, userBNumber) {
    let userAGet = new Promise((resolve, reject) => {
        this.nexmo.numberInsight.get({ level: 'basic', number: userANumber }, (error, result) => {
            if (error) {
                console.error(error);
                reject(`Check for ${userANumber} failed`);
            }
            else {
                console.log(result);
                resolve(result)
            }
        });
    });

    let userBGet = new Promise((resolve, reject) => {
        this.nexmo.numberInsight.get({ level: 'basic', number: userBNumber }, (error, result) => {
            if (error) {
                console.error(error);
                reject(`Check for ${userBNumber} failed`);
            }
            else {
                console.log(result);
                resolve(result)
            }
        });
    });

    return Promise.all([userAGet, userBGet]);
}
```

### Map real numbers to virtual numbers

Once you are sure that the phone numbers are valid, map each real number to one of your provisioned virtual numbers and save the information.

Perform this mapping in the `saveConversation()` class method:

```javascript
saveConversation(results) {
    const userAResult = results[0];
    const userANumber = {
        msisdn: userAResult.international_format_number,
        country: userAResult.country_code
    };

    const userBResult = results[1];
    const userBNumber = {
        msisdn: userBResult.international_format_number,
        country: userBResult.country_code
    };

    // Create conversation object - for demo purposes:
    // - Use first indexed LVN for user A
    // - Use second indexed LVN for user B

    const virtualNumbers = this.provisionedNumbers

    const conversation = {
        userA: {
            realNumber: userANumber,
            virtualNumber: virtualNumbers[0]
        },
        userB: {
            realNumber: userBNumber,
            virtualNumber: virtualNumbers[1]
        }
    };

    this.conversations.push(conversation);

    return conversation;
}
```

### Send a confirmation SMS

> **Note**: In this tutorial each user receives the virtual number via an SMS. In production systems this could be supplied using email, in-app notifications or as a predefined number.

Send each user a confirmation SMS from the virtual number of the other user.

Create the `sendSMS()` class method for this:

```javascript
sendSMS(conversation) {
    // Send UserA conversation information
    // From the UserB virtual number
    // To the UserA real number
    this.nexmo.message.sendSms(conversation.userB.virtualNumber.msisdn,
        conversation.userA.realNumber.msisdn,
        'Reply to this SMS to talk to UserB');

    // Send UserB conversation information
    // From the UserA virtual number
    // To the UserB real number
    this.nexmo.message.sendSms(conversation.userA.virtualNumber.msisdn,
        conversation.userB.realNumber.msisdn,
        'Reply to this SMS to talk to UserA');

    return conversation;
}
```

## Process inbound SMS

In an private communication system, when one user contacts another, he or she texts a virtual number from their phone. 

 When Nexmo receives an inbound SMS on one of these virtual numbers it makes an HTTP request to the webhook endpoint associated with the virtual number.

```js_sequence_diagram
Participant App
Participant Nexmo
Participant UserA
Participant UserB
Note over UserA,Nexmo: UserA sends SMS\nto UserB's\nVirtual Number
UserA->Nexmo: SMS to virtual number
Nexmo->App:Inbound SMS(from, to, text)
```

We have configured the webhook endpoint for each virtual number. Now, we just need to code the route handler for that endpoint.

In `server.js`, add a route for the `/inbound-sms` webhook request. Retrieve the `to`, `from` and `text` from the inbound request, and pass it to the `SmsProxy` class `proxySMS()` method (which we create in the [proxy the SMS](#proxy-the-sms) step). 

```javascript
app.post('/inbound-sms', (req, res) => {
  let from = req.body.msisdn;
  let to = req.body.to;
  let text = req.body.text;

  console.log("Text from : " + from + "\nMessage : " + text);
  
  smsProxy.proxySms(from, to, text);
  
  res.sendStatus(200);
});
```

### Determine where to send the SMS

Now that you know the real number of the user sending the SMS, you can work out which virtual number to send it to:

* If the `from` number is `UserA`'s real number, the `to` number is `UserB`'s virtual number
* If the `from` number is `UserB`'s real number, the `to` number is `UserA`'s virtual number

```javascript
getProxyRoute(from, to) {
    let proxyRoute = null;
    let conversation;

    this.conversations.some((conversation, index) => {
        // Use to and from to determine the conversation
        const fromUserA = this.fromUserAToUserB(from, to, conversation);
        const fromUserB = this.fromUserBToUserA(from, to, conversation);    
        
        if (fromUserA || fromUserB) {
            proxyRoute = {
                to: fromUserA ? conversation.userB : conversation.userA,
                from: fromUserA ? conversation.userA : conversation.userB
            };
            return true;
        }
    });
    return proxyRoute;
}

fromUserAToUserB(from, to, conversation) {
    return (from === conversation.userA.realNumber.msisdn &&
        to === conversation.userB.virtualNumber.msisdn);
}

fromUserBToUserA(from, to, conversation) {
    return (from === conversation.userB.realNumber.msisdn &&
        to === conversation.userA.virtualNumber.msisdn);
}
```

Now all you have to do is proxy the SMS from the recipient's virtual number to their real number.

### Proxy the SMS

Proxy the SMS to the real phone number that the target virtual number is associated with. The `from` number is always the virtual number, the `to` is the user's real phone number.

```js_sequence_diagram
Participant App
Participant Nexmo
Participant UserA
Participant UserB
UserA->Nexmo:
Nexmo->App:
App->Nexmo:Send SMS (proxy)
Note right of App:Proxy Inbound\nSMS to UserB's\nreal number
Nexmo->UserB: SMS
Note over UserA,UserB:UserA has sent\nan SMS to UserB.\nBut UserA does\nnot have the\n real number\nof UserB, nor\n vice versa.
```

```javascript
proxySms(from, to, text) {
    // Determine how the SMS should be routed
    let proxyRoute = this.getProxyRoute(from, to);

    if (proxyRoute === null) {
        let errorText = 'No booking found' +
            ' from: ' + from +
            ' to: ' + to;
        throw new Error(errorText);
    }

    // Always send
    // - from the virtual number
    // - to the real number
    this.nexmo.message.sendSms(proxyRoute.from.virtualNumber.msisdn,
        proxyRoute.to.realNumber.msisdn,
        text);
}
```

## Try it out

If you have been following along, you can test your application by providing two real phone numbers to the `SmsProxy` class `createConversation()` method. Just change the code in `server.js` as shown below, replacing `USERA_NUMBER` and `USERB_NUMBER` with two valid mobile phone numbers in [international format](/concepts/guides/glossary#number-format):

```javascript
...
const SmsProxy = require('./SmsProxy');
const smsProxy = new SmsProxy();
smsProxy.createConversation(USERA_NUMBER, USERB_NUMBER, (err, result) => {
    if(err) {
        res.status(500).json(err);
    }
    else {
        res.json(result);
    }
}); 
...
```

Run the application by executing the following at a terminal prompt:

```sh
node server.js
```

Alternatively, you can find a full working version of this tutorial [on GitHub](https://github.com/Nexmo/node-sms-proxy) with some extra routes and configuration that will make it easier to test.

## Conclusion

In this tutorial, you learned how to build an SMS proxy to enable two users to exchange SMS without either learning the other's real number. 

This involved:

* Searching for, renting and configuring virtual numbers using the [Numbers API](/numbers/overview)
* Validating users' phone numbers using the [Number Insight API](/number-insight/overview)
* Handling inbound SMS and proxying it to the correct user with the [SMS API](/messaging/sms/overview)

## Where Next?

The following resources will help you find out more about what you learned in this tutorial:

* [Tutorial code on GitHub](https://github.com/Nexmo/node-sms-proxy)
* [Private SMS use case](https://www.nexmo.com/use-cases/private-sms-communication)
* [SMS API reference guide](/api/sms)
* [Numbers API reference](/api/numbers)
* [Number Insight API reference](/api/number-insight)
* [Other SMS API tutorials](/messaging/sms/tutorials)
* [Setting up and using Ngrok](https://www.nexmo.com/blog/2017/07/04/local-development-nexmo-ngrok-tunnel-dr/)
