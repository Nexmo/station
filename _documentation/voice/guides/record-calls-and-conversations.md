---
title: Record calls and conversations
description: Record the audio from a Call or Conversation.
---

#Record calls and conversations

Recordings are contextual, they are attached to the UUID of each leg in a Call or a Conversation. You use different NCCOs to record:  

* Calls - you set the [record](/voice/guides/ncco-reference#record) action at the start of your NCCO so everything is recorded. Recording starts when the *record* action is executed in the NCCO and finishes when the synchronous condition in the action is met. That is, *endOnSilence*, *timeOut* or *endOnKey*. If you do not set a synchronous condition, the Voice API immediately executes the next NCCO without recording.
* Conversations - you set the *record* option in the [conversation](/voice/guides/ncco-reference#conversation) action. For standard conversations, recordings start when one or more attendee connects to the conversation and terminate when the last attendee disconnects. For moderated conversations, recordings start when the moderator joins. That is, when an NCCO is executed for the named conversation where ‘startOnEnter’ is set to *true*. When the recording is terminated, the URL you download the recording from is sent to the event URL.

The workflow to create a recording is:

1. You use the *record* NCCO action to record an active Call or Conversation:

    ```tabbed_content
    source: '/_examples/voice/guides/record-calls-and-conversations/ncco'
    ```

    By default audio is recorded in MP3 format.

2. When the Call or Conversation is complete, information about the recording is sent to the webhook URL you set in the *eventUrl* option.

    ```json
    {
      "start_time": "2016-09-14T13:21:55Z",
      "recording_url": "https://api.nexmo.com/media/download?id=5345cf0-345c-34b3-a23b-ca6ccfe144b0",
      "size": 84413,
      "recording_uuid": "53383284-b36d-498c-b733-aa0234c2234",
      "end_time": "2016-09-14T13:22:17Z",
      "conversation_uuid": "aa5c81cb-78ef-4e28-234-801c0ea234"
    }
    ```


    > **Note**: `recording_uuid` is not the same as the file uuid in `recording_url`. See the [parameters](/api/voice#ccwebhook) sent to eventURL.

3. Make a GET request using your JWT for authentication in order to retrieve the recording from *recording_url*.

    ```tabbed_examples
    source: '/_examples/voice/guides/record-calls-and-conversations/retrieve-recording'
    ```

    > *Note*: After your recording is complete, it is stored by Nexmo for 30 days.
