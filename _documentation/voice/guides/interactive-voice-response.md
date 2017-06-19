---
title: Interactive Voice Response (IVR)
---
# Interactive Voice Response (IVR)

With the Voice API you easily create an IVR by generating NCCOs in a webhook.

Interactive Voice Response (IVR) is a technology that allows a computer to interact with humans through the use of voice and DTMF tones input on the handset keypad. You create IVR systems for mobile purchases, banking payments and services, retail orders, utilities, travel information and weather conditions.

In this section you will see how to build an IVR system using Nexmo APIs:

* [Prerequisites](#prerequisites) - rent and configure a virtual number for your IVR
* [Create your IVR](#create_ncco) - user NCCOs to create an experience for your user

## Prerequisites

To follow the steps in this tutorial you need to:

* Setup a [Nexmo account](/account/guides/management#create-and-configure-a-nexmo-account)
* Rent a virtual number using [Dashboard](/account/guides/numbers#rent-virtual-numbers) or [Developer API](/api/developer/numbers#buy-a-number) and set the webhook endpoint to your app
* [Create an application](/concepts/guides/applications#apps_quickstart) and associate it with your virtual number. Nexmo retrieves the initial NCCO from the *answer_url* webhook and sends the dtmf input to the *eventUrl* webhook defined in the initial NCCO

## Create your IVR

In an IVR, when your user calls your virtual number you first send welcome message using text-to-speech or an audio stream. This message tells your user which button to push for your available services.  Then, in function of the *dtmf* input, you generate the NCCOS that create a customized experience for your user.

Using *bargeIn*, your user does not have to listen to the whole announcement. If he or she already knows the choices, when they press an option during a *talk* or *stream* action, the announcement is stopped and the IVR executes their instruction. BargeIn makes the *talk* or *stream* actions asynchronous. You must set an *input* action later in the NCCO stack.

The workflow for an IVR is:

```js_sequence_diagram
Participant answer_url
Participant eventUrl
Participant Nexmo
Participant User
User->Nexmo: Call virtual number
Nexmo->answer_url: Send call info
answer_url->Nexmo: Return NCCO with options\n Set eventUrl
Nexmo->User: Send welcome message set in NCCO
User->Nexmo: Press digits in function of welcome message
Nexmo->eventUrl: Send dtmf input
eventUrl->Nexmo: Send customized NCCO\n in function of dtmf input
Note over Nexmo: Execute actions in NCCO
Nexmo->User: Customized user experience
```

To implement this workflow:

1. Supply your users with a virtual number to contact.

2. When a user calls the virtual numbers, Nexmo forwards information about the Call to your webhook endpoint.

3. At the webhook endpoint, store the caller information and send an NCCO with the welcome message and options:

    ```tabbed_examples
    source: '_examples/voice/guides/interactive-voice-response/1'
    ```

4. Your user hears the welcome message and presses a key to choose an option.

5. Your code at the <i>eventUrl</i> webhook endpoint returns a customized NCCO in function of the keys pressed by your user:

    ```tabbed_examples
    source: '_examples/voice/guides/interactive-voice-response/2'
    ```

And that's it. You have built an IVR. To do this you have provisioned and configured a virtual number, sent a generic welcome message, handled inbound calls and created a customized experience for your user.
