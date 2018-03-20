---
title: Record calls and conversations
description: Record the audio from a Call or Conversation.
---

#Record calls and conversations

Recordings are attached to the UUID of a Call Leg or Conversation. Different NCCOs are used to record in different contexts.

* Record a message - You can use the `record` action to  record audio from a caller without continuing to the next action, this would be used for a voicemail style of scenario. To use `record` in this mode set a synchronous flag namely `endOnSilence` or `endOnKey` within your action.
* Record Calls between two people - you can set the [record](/voice/guides/ncco-reference#record) action at the start of your NCCO so everything is recorded. Recording starts when the `record` action is executed If you do not set a synchronous condition, the Voice API immediately executes the next NCCO without recording.
* Split Recording - when recording a call, you can enable split recording which will result in the recording being a stereo file with one channel having the audio sent from the caller and another channel being the audio heard by the caller. This only applies when recording a call between two people.
* Conversations - you set the `record` option in the [conversation](/voice/guides/ncco-reference#conversation) action. For standard conversations, recordings start when one or more attendee connects to the conversation and terminate when the last attendee disconnects. For moderated conversations, recordings start when the moderator joins. That is, when an NCCO is executed for the named conversation where `startOnEnter` is set to *true*. When the recording is terminated, the URL you download the recording from is sent to the event URL.

The workflow to create a recording is:

1. Use the *record* NCCO action to record an active Call or Conversation:

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
