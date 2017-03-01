---
title: API reference
description: Voice API reference
---

# API reference

## Calls

You use the following requests to create, terminate, record and retrieve information about your Calls:

###  Create an outbound call

[POST] `https://api.nexmo.com/v1/calls`

```tabbed_examples
source: '/_examples/api/voice/calls/post'
```

This request contains:

* A [Base URL](#ccbase)
* [Payload](#ccparameters )
* [JWT](#jwt_minting)

Information about the Call is sent to you in the:

* [Response](#ccresponse) - parameters sent synchronously when the Call starts.
* [Webhook](#ccwebhook) - parameters sent asynchronously when the status changes


#### Base URL

All requests to create a Call must contain:

* `https://api.nexmo.com/v1/calls`

#### Payload

The payload to create a new Call looks like:

```tabbed_content
source: '/_examples/api/voice/calls/post-response'
```


The following table shows the parameters you use to create a Call:

Parameter | Description | Required
-- | -- | --
`to` | The single or mixed collection of endpoint types you connected to. @[Possible values](/_modals/voice/guides/ncco-reference/endpoint.md).
`from` | The endpoint you are calling from. Possible value are the same as *to*. | Yes
`answer_url` | The webhook endpoint where you provide the Nexmo Call Control Object that governs this Call. As soon as your user answers a call, Platform requests this NCCO from `answer_url`. Use `answer_method` to manage the HTTP method. | yes
`answer_method` | A [GET] request. | no
`event_url` | Platform sends event information asynchronously to this endpoint when status changes. For more information about the values sent, see Callback. | no
`machine_detection` | Configure the behavior when Nexmo detects that a destination is an answerphone. @[Possible values](/_modals/voice/api/calls/machine_detection.md). | no
`length_timer` | Set the number of seconds that elapse before Nexmo hangs up after the Call state changes to *in_progress*. The default value is 7200, two hours. This is also the maximum value. | No that elapse before Nexmo hangs up after the Call state changes to *‘ringing’*. The default value is 60, the maximum value is 120. | No
`ringing_timer` | Set the number of seconds that elapse before Nexmo hangs up after the Call state changes to ‘ringing’. The default value is 60, the maximum value is 120. | no

#### Response

The JSON response looks like:

```json
{
  "uuid": "19d4df7c-d0dd-40c5-8460-1e88bd5d0d6b",
  "conversation_uuid": "63f61863-4a51-4f6b-86e1-46edebio0391",
  "status": "started",
  "direction": "outbound"
}
```

The 201 response contains the following keys and values:

Key | Value
-- | --
`uuid` | The unique identifier for this call leg. The uuid is created when your call request is accepted by Nexmo. You use uuid in all requests for individual live calls. @[Possible values](/_modals/voice/api/calls/uuid.md).
`conversation_uuid` | The unique identifier for the conversation this call leg is part of.
`direction` | Possible values are `outbound` or `inbound`.
`status` | The status of the call. @[Possible values](/_modals/voice/api/calls/status.md).

#### Webhook

Nexmo sends the following parameters asynchronously to [event_url](#event_url) when [*status* changes](voice/voice-api/handle-call-state):

```tabbed_content
source: '/_examples/api/voice/calls/webhook'
```

> **Note**: all return parameters are only sent when *status* is *completed*.

Possible values are:

Key | Value
-- | --
`uuid` | The unique identifier for this call leg. The uuid is created when your call request is accepted by Nexmo. You use uuid in all requests for individual live calls. @[Possible values](/_modals/voice/api/calls/uuid.md).
`conversation_uuid` | The unique identifier for the conversation this call leg is part of.
`to` |
`direction` | Possible values are `outbound` or `inbound`.
`status` | The status of the call. @[Possible values](/_modals/voice/api/calls/status.md).

### [GET] `https://api.nexmo.com/v1/calls`

You use a GET request to retrieve the details about all your Calls.

<ul class="nav nav-tabs">
  <li class="active"><a data-toggle="tab" href="#call_list_php">PHP</a></li>
  <li ><a data-toggle="tab" href="#call_list_python">Python</a></li>
  <li ><a data-toggle="tab" href="#call_list_ruby">Ruby</a></li>
	</ul>
<div class="tab-content">
	<div id="call_list_php" class="tab-pane fade in active">(nexcode: call_list.php lang: php product: voice_api)</div>
	<div id="call_list_python" class="tab-pane fade">(nexcode: call_list.py lang: python product: voice_api)</div>
	<div id="call_list_ruby" class="tab-pane fade">(nexcode: call_list.rb lang: ruby product: voice_api)</div>
</div>


This request contains:

* A [Base URL](#crabase)
* [Parameters](#craparameters)
* [JWT](#jwt_minting)

You receive the Call details in the [response](#craresponse),

#### Base URL

All requests to retrieve details about all your Calls must contain:

* `https://api.nexmo.com/v1/calls`

#### Parameters

The following table shows the parameters you use to filter the information you retrieve about your Calls:

Parameter | Description | Required
--- | --- | ---
| status | Filter on the status of this Call.  Possible values are: <ul><li>started - Nexmo has stared the call.</li><li>ringing - the user's handset is ringing.</li><li>answered - the user has answered your call. </li><li>timeout - your user did not answer your call with <a href="#ringing_timer">ringing_timer</a>.</li><li>machine - Nexmo detected an answering machine.</li><li>completed - Nexmo has terminated this call.</li></ul>| No
(vapi_pagination_request: nutin)


#### Response

The JSON response looks like:

(nexpayload:  call_list.json lang: json product: voice_api )

The 200 response contains the following keys and values:

| Key | Value |
| --- | --- |
(vapi_collection_response: nutin)
(appapi_links_response: nutin)
| _embedded | The collections of JSON objects returned in this response.
| calls | The collection of *page_size* Calls returned by your request. Each Call in this response has the parameters listed below.
(vapi_pagination_response: nutin)
(appapi_links_response: nutin)

### [GET] `https://api.nexmo.com/v1/calls/{uuid}`

You use a GET request to retrieve information about a single Call.

<ul class="nav nav-tabs">
  <li class="active"><a data-toggle="tab" href="#call_retrieve_php">PHP</a></li>
  <li ><a data-toggle="tab" href="#call_retrieve_python">Python</a></li>
  <li ><a data-toggle="tab" href="#call_retrieve_ruby">Ruby</a></li>
	</ul>
<div class="tab-content">
	<div id="call_retrieve_php" class="tab-pane fade in active">(nexcode: call_retrieve.php lang: php product: voice_api)</div>
	<div id="call_retrieve_python" class="tab-pane fade">(nexcode: call_retrieve.py lang: python product: voice_api)</div>
	<div id="call_retrieve_ruby" class="tab-pane fade">(nexcode: call_retrieve.rb lang: ruby product: voice_api)</div>
</div>


This request contains:

* A [Base URL](#crsbase)
* (link: #crsparameterstext: Payload)
* [JWT](#jwt_minting)

You receive the Call details in the [response](#crsresponse).

#### Base URL

All requests to retrieve information about a single Call must contain:

* `https://api.nexmo.com/v1/calls/{uuid}`

#### Payload

There are no parameters for this request.

#### Response

The JSON responses looks like:

<ul class="nav nav-tabs">
  <li class="active"><a data-toggle="tab" href="#callcomplete">Call completed</a></li>
  <li><a data-toggle="tab" href="#callinprogress">Call in progress</a></li>
	</ul>
<div class="tab-content">
	<div id="callcomplete" class="tab-pane fade in active">(nexcode: call_retrieve_single_response_complete.json lang: json product: voice_api)</div>
  <div id="callinprogress" class="tab-pane fade">(nexcode: call_retrieve_single_response_inprogress.json lang: json product: voice_api)</div>
</div>

The 200 response contains the following keys and values:

Key | Value
-- | --
(appapi_links_response: nutin)
(vapi_pagination_response: nutin)

### [PUT] `https://api.nexmo.com/v1/calls/{uuid}`

You use a PUT request to modify an existing Call.
<ul class="nav nav-tabs">
  <li class="active"><a data-toggle="tab" href="#call_modify_php">PHP</a></li>
  <li ><a data-toggle="tab" href="#call_modify_python">Python</a></li>
  <li ><a data-toggle="tab" href="#call_modify_ruby">Ruby</a></li>
	</ul>
<div class="tab-content">
	<div id="call_modify_php" class="tab-pane fade in active">(nexcode: call_modify.php lang: php product: voice_api)</div>
	<div id="call_modify_python" class="tab-pane fade">(nexcode: call_modify.py lang: python product: voice_api)</div>
	<div id="call_modify_ruby" class="tab-pane fade">(nexcode: call_modify.rb lang: ruby product: voice_api)</div>
</div>


This request contains:

* A [Base URL](#cmsbase)
* [Payload](#cmsparameters )
* [JWT](#jwt_minting)

You receive details about the Call in the [response](#cmsresponse).

#### Base URL
All requests to modify an existing Call must contain:

* `https://api.nexmo.com/v1/calls/{uuid}`

#### Payload

The payload to modify a Call looks like.

<ul class="nav nav-tabs">
  <li class="active"><a data-toggle="tab" href="#call_modify_hangup">Hangup</a></li>
	</ul>
<div class="tab-content">
	<div id="call_modify_hangup" class="tab-pane fade in active">(nexcode: call_modify_hangup.json lang: json product: voice_api)</div>
</div>

The following table shows the parameters you use to modify a Call:

Parameter | Description | Required
--- | --- | ---
action | Use one of the following options to modify *uuid*: <ul><li>hangup - end this Call.</li></ul> | Yes


#### Response

The JSON response looks like:

(nexpayload:  call_modify_one_active_response.json lang: json product: voice_api )

The 200 response contains the following keys and values:

| Key | Value |
| --- | --- |
(appapi_links_response: nutin)
(vapi_pagination_response: nutin)

## Streams
You use the following requests to start and stop streaming audio to an active Call:

* <a href="#stream_put">PUT `https://api.nexmo.com/v1/calls/{uuid}/stream`</a> - stream an audio file to an active Call
* <a href="#stream_delete">DELETE `https://api.nexmo.com/v1/calls/{uuid}/stream`</a> - stop streaming an audio file to an active Call

### [PUT] `https://api.nexmo.com/v1/calls/{uuid}/stream`

You use a PUT request to stream an audio file to an active Call.
<ul class="nav nav-tabs">
  <li class="active"><a data-toggle="tab" href="#call_stream_php">PHP</a></li>
  <li ><a data-toggle="tab" href="#call_stream_python">Python</a></li>
  <li ><a data-toggle="tab" href="#call_stream_ruby">Ruby</a></li>
	</ul>
<div class="tab-content">
	<div id="call_stream_php" class="tab-pane fade in active">(nexcode: call_stream.php lang: php product: voice_api)</div>
	<div id="call_stream_python" class="tab-pane fade">(nexcode: call_stream.py lang: python product: voice_api)</div>
	<div id="call_stream_ruby" class="tab-pane fade">(nexcode: call_stream.rb lang: ruby product: voice_api)</div>
</div>


This request contains:

* A [Base URL](#cspbase)
* [Payload](#cspparameters )
* [JWT](#jwt_minting)

Information about streaming is sent to you in the:

* [Response](#cspresponse) - parameters sent synchronously when streaming starts.

#### Base URL
All requests must contain:

* `https://api.nexmo.com/v1/calls/{uuid}/stream`

#### Payload

The following table shows the parameters you use to stream audio to a Call:

Parameter | Description | Required
--- | --- | ---
stream_url | An array containing a single URL to an mp3 or wav (16-bit) audio file to stream to the Call or Conversation. | Yes
loop | The number of times the audio file at *stream_url* is repeated before the stream ends. The default value is 1. Set to 0 to loop infinitely. | No

#### Response

The JSON response looks like:

(nexpayload:  call_stream_put_response.json lang: json product: voice_api )

The 200 response contains the following keys and values:

| Key | Value |
|---- | --- |
(vapi_stream_talk_dtmf_response: nutin)

### [DELETE] `https://api.nexmo.com/v1/calls/{uuid}/stream`

You use a DELETE request to stop streaming audio to an active Call.
<ul class="nav nav-tabs">
  <li class="active"><a data-toggle="tab" href="#call_stream_stop_php">PHP</a></li>
  <li ><a data-toggle="tab" href="#call_stream_stop_python">Python</a></li>
  <li ><a data-toggle="tab" href="#call_stream_stop_ruby">Ruby</a></li>
	</ul>
<div class="tab-content">
	<div id="call_stream_stop_php" class="tab-pane fade in active">(nexcode: call_stream_stop.php lang: php product: voice_api)</div>
	<div id="call_stream_stop_python" class="tab-pane fade">(nexcode: call_stream_stop.py lang: python product: voice_api)</div>
	<div id="call_stream_stop_ruby" class="tab-pane fade">(nexcode: call_stream_stop.rb lang: ruby product: voice_api)</div>
</div>


This request contains:

* A [Base URL](#csdbase)
* [Payload](#csdparameters )
* [JWT](#jwt_minting)

Information about streaming is sent to you in the:

* [Response](#csdresponse) - parameters sent synchronously when the streaming stops.

#### Base URL
All requests must contain:

* `https://api.nexmo.com/v1/calls/{uuid}/stream`

#### Payload

There are no parameters for this request.

#### Response

The JSON response looks like:

(nexpayload:  call_stream_delete_response.json lang: json product: voice_api )

The 200 response contains the following keys and values:

| Key | Value |
|---- | --- |
(vapi_stream_talk_dtmf_response: nutin)


## Talk

You use the following requests to start and stop synthesized audio messages in an active Call:

* <a href="#talk_put">PUT `https://api.nexmo.com/v1/calls/{uuid}/talk`</a> - send a synthesized speech message to an active Call
* <a href="#talk_delete">DELETE `https://api.nexmo.com/v1/calls/{uuid}/talk`</a> - stop sending a synthesized speech message to an active Call

### [PUT] `https://api.nexmo.com/v1/calls/{uuid}/talk`

You use a PUT request to send a synthesized speech message to an active Call.
<ul class="nav nav-tabs">
  <li class="active"><a data-toggle="tab" href="#call_talk_php">PHP</a></li>
  <li ><a data-toggle="tab" href="#call_talk_python">Python</a></li>
  <li ><a data-toggle="tab" href="#call_talk_ruby">Ruby</a></li>
	</ul>
<div class="tab-content">
	<div id="call_talk_php" class="tab-pane fade in active">(nexcode: call_talk.php lang: php product: voice_api)</div>
	<div id="call_talk_python" class="tab-pane fade">(nexcode: call_talk.py lang: python product: voice_api)</div>
	<div id="call_talk_ruby" class="tab-pane fade">(nexcode: call_talk.rb lang: ruby product: voice_api)</div>
</div>


This request contains:

* A [Base URL](#ctpbase)
* [Payload](#ctpparameters )
* [JWT](#jwt_minting)

Information about streaming is sent to you in the:

* [Response](#ctpresponse) - parameters sent synchronously when streaming starts.

#### Base URL
All requests must contain:

* `https://api.nexmo.com/v1/calls/{uuid}/talk`

#### Payload

The following table shows the parameters you use to send synthesized audio to a Call:

<table>
<thead>
<tr>
<th>Parameter</th>
<th>Description</th>
<th>Required</th>
</tr>
</thead>
<tbody>
<tr><td>text</td><td>A UTF-8 and URL encoded string of up to 1500 characters containing the message to be synthesized in the Call or Conversation. Each comma in <i>text</i> adds a short pause to the synthesized speech.</td><td>Yes </td></tr>
<tr><td>voice_name</td><td markdown="1">
The name of the voice used to deliver `text`. You use the `voice_name` that has the correct language, gender and accent for the message you are sending. For example, the default voice `Kimberly` is a female who speaks English with an American accent (en-US). Possible values for `voice_name` are:

* Salli - en-US female
* Joey - en-US male
* Naja - da-DK femaleMads - da-DK male
* Marlene - de-DE female
* Hans - de-DE male
* Nicole - en-AU female
* Russell - en-AU male
* Amy - en-GB female
* Brian - en-GB male
* Emma - en-GB female
* Gwyneth - en-GB-WLS female
* Geraint - en-GB-WLS male
* Gwyneth - cy-GB-WLS female
* Geraint - cy-GB-WLS male
* Raveena - en-IN female
* Chipmunk - en-US male
* Eric - en-US male
* Ivy - en-US female
* Jennifer - en-US female
* Justin - en-US male
* Kendra - en-US female
* Kimberly - en-US female
* Conchita - es-ES female
* Enrique - es-ES male
* Penelope - es-US female
* Miguel - es-US male
* Chantal - fr-CA female
* Celine - fr-FR female
* Mathieu - fr-FR male
* Dora - is-IS female
* Karl - is-IS male
* Carla - it-IT female
* Giorgio - it-IT male
* Liv - nb-NO female
* Lotte - nl-NL female
* Ruben - nl-NL male
* Agnieszka - pl-PL female
* Jacek - pl-PL male
* Ewa - pl-PL female
* Jan - pl-PL male
* Maja - pl-PL female
* Vitoria - pt-BR female
* Ricardo - pt-BR male
* Cristiano - pt-PT male
* Ines - pt-PT female
* Carmen - ro-RO female
* Maxim - ru-RU male
* Tatyana - ru-RU female
* Astrid - sv-SE female
* Filiz - tr-TR female

</td><td>No</td></td></tr>
<tr><td>loop</td><td>The number of times the audio file at <i>stream_url</i> is repeated before the stream ends. The default value is <i>1</i>. Set to <i>0</i> to loop infinitely.</td><td>No </td></tr>
</tbody>
</table>


#### Response

The JSON response looks like:

(nexpayload:  call_talk_put_response.json lang: json product: voice_api )

The 200 response contains the following keys and values:

| Key | Value |
|---- | --- |
(vapi_stream_talk_dtmf_response: nutin)

### [DELETE] `https://api.nexmo.com/v1/calls/{uuid}/talk`

You use a DELETE request to stop send synthesized audio to an active Call.
<ul class="nav nav-tabs">
  <li class="active"><a data-toggle="tab" href="#call_talk_stop_php">PHP</a></li>
  <li ><a data-toggle="tab" href="#call_talk_stop_python">Python</a></li>
  <li ><a data-toggle="tab" href="#call_talk_stop_ruby">Ruby</a></li>
	</ul>
<div class="tab-content">
	<div id="call_talk_stop_php" class="tab-pane fade in active">(nexcode: call_talk_stop.php lang: php product: voice_api)</div>
	<div id="call_talk_stop_python" class="tab-pane fade">(nexcode: call_talk_stop.py lang: python product: voice_api)</div>
	<div id="call_talk_stop_ruby" class="tab-pane fade">(nexcode: call_talk_stop.rb lang: ruby product: voice_api)</div>
</div>


This request contains:

* A [Base URL](#ctdbase)
* [Payload](#ctdparameters )
* [JWT](#jwt_minting)

Information about the synthesized audio is sent to you in the:

* [Response](#ctdresponse) - parameters sent synchronously when the synthesized audio stops.

#### Base URL
All requests must contain:

* `https://api.nexmo.com/v1/calls/{uuid}/talk`

#### Payload

There are no parameters for this request.


#### Response

The JSON response looks like:

(nexpayload:  call_talk_delete_response.json lang: json product: voice_api )

The 200 response contains the following keys and values:

| Key | Value |
|---- | --- |
(vapi_stream_talk_dtmf_response: nutin)

## DTMF

You use the following requests to use DTMF in your Calls:

* <a href="#dtmf_put">PUT `https://api.nexmo.com/v1/calls/{uuid}/dtmf`</a> - send Dual-tone multi-frequency(DTMF) tones to an active Call

### [PUT] `https://api.nexmo.com/v1/calls/{uuid}/dtmf`

You use a PUT request to send DTMF tones to an active Call.
<ul class="nav nav-tabs">
  <li class="active"><a data-toggle="tab" href="#call_dtfm_php">PHP</a></li>
  <li ><a data-toggle="tab" href="#call_dtfm_python">Python</a></li>
  <li ><a data-toggle="tab" href="#call_dtfm_ruby">Ruby</a></li>
	</ul>
<div class="tab-content">
	<div id="call_dtfm_php" class="tab-pane fade in active">(nexcode: call_dtfm.php lang: php product: voice_api)</div>
	<div id="call_dtfm_python" class="tab-pane fade">(nexcode: call_dtfm.py lang: python product: voice_api)</div>
	<div id="call_dtfm_ruby" class="tab-pane fade">(nexcode: call_dtfm.rb lang: ruby product: voice_api)</div>
</div>


This request contains:

* A [Base URL](#dtmfbase)
* [Payload](#dtmfparameters )
* [JWT](#jwt_minting)

Information about this request is sent to you in the:

* [Response](#dtmfresponse) - parameters sent synchronously when you send DTMF tones.

#### Base URL
All requests must contain:

* `https://api.nexmo.com/v1/calls/{uuid}/dtmf`

#### Payload

The following table shows the parameters you use to stream audio to a Call:

Parameter | Description | Required
--- | --- | ---
digits | The array of digits to send to the Call | Yes

#### Response

The JSON response looks like:

(nexpayload:  call_dtmf_put_response.json lang: json product: voice_api )

The 200 response contains the following keys and values:

| Key | Value |
|---- | --- |
(vapi_stream_talk_dtmf_response: nutin)


##Security and authentication

Each call you make to this API must have:

* [Security](#security )
* [Encoding](#encode)

(security_encoding: somevalue)

## Generating a JWT

You use JWTs to authenticate calls to Nexmo APIs for your application. You generate a JWT by encrypting a JSON object containing the ID and private key of your application plus the current time. You add your JWT to the header in your requests to Nexmo API. The JWT authenticates your requests and tells Nexmo which application you are using.

A JWT consists of a header, a payload and a signature in the structure xxxxx.yyyyy.zzzzz. For more information, see  <https://jwt.io/introduction/> and the [JWT reference ](tools/application-api/application-security#reference).

The following code examples show how to generate a JWT token:

<ul class="nav nav-tabs">
  <li class="active"><a data-toggle="tab" href="#application_jwt_mint_php">PHP</a></li>
  <li ><a data-toggle="tab" href="#application_jwt_mint_python">Python</a></li>
  <li ><a data-toggle="tab" href="#application_jwt_mint_ruby">Ruby</a></li>
	</ul>
<div class="tab-content">
	<div id="application_jwt_mint_php" class="tab-pane fade in active">(nexcode: application_jwt_mint.php lang: php product: application_api)</div>
	<div id="application_jwt_mint_python" class="tab-pane fade">(nexcode: application_jwt_mint.py lang: python product: application_api)</div>
	<div id="application_jwt_mint_ruby" class="tab-pane fade">(nexcode: application_jwt_mint.rb lang: ruby product: application_api)</div>
</div>

When you use JWTs for authentication, you must still follow [Security](#security ) and [Encoding](#encode).

(nexmo_errors: somevalue)
