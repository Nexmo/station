---
title: Voice app components
---

# Voice app components

Your Voice app interacts with the Voice API to securely create, receive and control Voice communication with your users.

The components in a Voice app are:

![VAPI Architecture](/assets/images/vapi_architecture.svg)

* Outbound - this component:
  * Generates JSON Web Tokens (JWTs) using the *private_key* allocated to your Voice app
  * Makes requests to Voice API to create calls to one or more users
  * From webhook endpoints, provides the Nexmo Call Control Objects (NCCO) to control the calls
  * Customizes live calls following user interaction using the Voice API and NCCOs
* Inbound - From webhook endpoints, provides the NCCOs that handle inbound calls to and conferences hosted on the virtual number associated with this app
* Status - a webhook endpoint that handles the progression of a live call and downloads recordings when the call status is *complete*

Your Voice app components communicate with one or more users in either a:

* Conversation - a collection of one or more Calls. From an inbound text-to-speech message to a company conference call. The audio is a mix of all legs connected to the Conversation.
* Call - a single leg connected to a Conversation. The audio in a Call consists of transmitted audio (Tx) and received audio (Rx). You use a Call to communicate between two end points.

A Conversation and the legs connected to it are identified by separate UUIDs (Universally Unique IDentifiers). This means you can manipulate Conversations and legs independently. For example, you can move a leg from one Conversation to another.

The following figure shows the components for a private voice communication system:

![Voice API Call](/assets/images/workflow_voice_api_call.svg)

Using the Voice API or NCCOs you can:

Action | NCCO | API
-- | -- | --
Connect to a phone number. | [`connect`](/voice/guides/ncco-reference#connect) | [`POST https://api.nexmo.com/v1/calls` ](/api/voice#create-an-outbound-call)
Record your Call. | [`record`](/voice/guides/ncco-reference#record) | &nbsp;
Create a standard or moderated conference. | [`conversation`](/voice/guides/ncco-reference#conversation) | &nbsp;
Send synthesized speech to a Call or Conversation. | [`talk`](/voice/guides/ncco-reference#talk) | [`PUT https://api.nexmo.com/v1/calls/{uuid}/talk` ](/api/voice#talk_put)
Send an audio stream to a Call or Conversation. | [`stream`](/voice/guides/ncco-reference#stream) | &nbsp;
Collect digits input by the person you are calling.  | [`input`](/voice/guides/ncco-reference#input) | &nbsp;
Send dual-tone multi-frequency signalling (DTMF) tones to an active call | &nbsp; | [`PUT https://api.nexmo.com/v1/calls/{uuid}/dtmf` ](/api/voice#dtmf_put)
