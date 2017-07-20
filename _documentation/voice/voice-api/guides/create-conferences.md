---
title: Create conferences
description: Voice API conversations.
---

#Create conferences

A Conversation is the collection of one or more inbound calls to the virtual number associated to your Voice app. A named Conversation is a conference. You use the *conversation* NCCO to create a standard or moderated conference for the callers. A standard conference starts when the first caller calls in and ends when the last caller hangs up. A moderated conference starts and ends when the moderator calls in and hangs up. Before a moderated conference starts, you can send an audio stream to the waiting participants. When a conference starts, all audio from all inbound calls is mixed into it. You can [record](/voice/guides/record-calls-and-conversations) standard and moderated conferences.

The workflow for a conference is:

![conference workflow](/assets/images/workflow_voice_api_inbound_conversation.svg)

1. Your users call the virtual number associated with your app.
2. Nexmo retrieves an NCCO from your `answer_url` webhook endpoint.
3. Nexmo follows the actions in your NCCO.
4. Nexmo sends status information to your webhook endpoint at `event_url`.

To create a conference with the Voice API:

1. [Create a Nexmo application](/concepts/guides/applications#apps_quickstart). Set `answer_url` to the URL of server that provides your NCCOs.  
2. Create the NCCOs for the business logic you are implementing in your Voice app:

    ```tabbed_content
    source: '_examples/voice/guides/create-conference/ncco'
    ```

3. Create the webhook that provides the NCCO for your conference. The following code examples use the request parameters sent to [`answer_url`](/voice/guides/ncco#controlling) to deliver one NCCO to the moderator and another to all other attendees:

    ```tabbed_examples
    source: '_examples/voice/guides/create-conference/webhook'
    ```

4. Handle the call state changes at <i>event_url</i>. If you [record](/voice/guides/record-calls-and-conversations) your Conversations, the download URL for the mp3 recording is sent to this webhook endpoint when *status* is *complete*. The following code examples show you how to handle changes in Conversation state:

    ```tabbed_examples
    source: '_examples/voice/guides/create-conference/handle-state-change'
    ```

    To inspect and debug state changes without writing your own server, create an online endpoint service such as [requestb.in](http://requestb.in/) or [https://hookbin.com/](https://hookbin.com/).

5. Your conference starts when somebody calls the virtual number associated with the application.

> **Note**: to dial somebody into the conference, [make an outbound call](/voice/guides/outbound-calls) to your user and set [answer_url](/api/voice#payload) to the [webhook endpoint](#conference_webhook) providing the [conference NCCO](#conference_ncco).

The maximum allowable calls is 50. Conversations can also be moderated and recorded.
