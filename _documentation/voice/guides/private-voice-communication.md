---
title: Private voice communication
---

# Private voice communication

For market place scenarios such as food delivery or taxi and passenger communications, if your users see each others phone number and bypass your marketplace, your application cannot track the communication threads. To avoid security and privacy concerns it is best practice that users do not have access to each other's phone numbers.

By implementing masked communication using the Voice API you ensure your users cannot bypass the required or preferred communication workflows and audits.

In this section you see how to build a voice proxy for masked communication system using Nexmo APIs:

* [Prerequisites](#prerequisites) - rent and configure the virtual numbers you use to mask phone numbers
* [Create your voice proxy NCCO](#create_ncco) - assign virtual numbers to phone numbers, then setup the NCCO to connect inbound calls to the masked phone number

## Prerequisites

To follow the steps in this tutorial you need to:

* Setup a [Nexmo account](/account/guides/management#create-and-configure-a-nexmo-account)
* Rent two virtual numbers using [Dashboard](/account/guides/numbers#rent-virtual-numbers) or [Developer API](https://docs.nexmo.com/tools/developer-api/number-buy)
* [Create an application](https://docs.nexmo.com/tools/application-api#apps_quickstart) and associate it with your virtual number. Nexmo retrieve the NCCO for both virtual numbers from the *answer_url* webhook endpoint in your application.

## Create your voice proxy NCCO

In a masked communication system you use your application to supply each user with the virtual number assigned to their contact. When one user contacts another, he or she calls the virtual number assigned to their contact. Nexmo forwards information about this call to your webhook endpoint at answer_url. Your code check the virtual number against the mapped phone number, then returns the NCCO to connect the inbound call to the masked phone number.

```js_sequence_diagram
Participant Application
Participant Nexmo
Participant UserA
Participant UserB
Note over Application,UserB: Supply users with each other's virtual number
UserA->Nexmo: Call
Nexmo->Application: User Message Received\n(from, to, conversation_uuid)
Application->Application:Number mapping lookup
Note right of Application:Find the real number for UserB
Application->Nexmo: Supply NCCO to connect to phone number
Nexmo->UserB: Connect
UserA->UserB: "Mr cab driver!"
UserB->UserA: "I'll stop to pick you up!"
Note over UserA,UserB: UserA and UserB are\n talking. \nNeither user knows\nthe phone \nnumber of the other.
```


1. Supply your users with the virtual number assigned to their contact.
2. When a user calls one of the virtual numbers, Nexmo forwards information about the Call to your webhook endpoint.
3. At the webhook endpoint, check the phone number for the caller and connect them to the real number for their contact:

    ```tabbed_examples
    source: '_examples/voice/guides/private-voice-communication/1'
    ```

4. Your users are connected to each other, neither knows the others real phone number.
5. Your code at the `eventUrl` webhook endpoint handles changes in the Call state:

    ```tabbed_examples
    source: '_examples/voice/guides/private-voice-communication/2'
    ```

And that's it. You have built an Voice proxy for masked communication. To do this you have provision and configure numbers, mapped real numbers to virtual numbers to ensure anonymity, handled inbound calls and connected them to your users.
