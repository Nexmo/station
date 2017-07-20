---
title: Accept inbound calls
description: Voice API conversations
---

# Accept inbound calls

An inbound call is when a single person calls the virtual number associated with your Voice app.

The workflow for incoming calls is:

![Inbound call workflow](/assets/images/workflow_voice_api_inbound_conversation.svg)

1. A user calls the virtual number associated with your application.
2. Nexmo retrieves the NCCO from your `answer_url` webhook endpoint.
3. Nexmo follows the actions in your NCCO.
4. Nexmo sends status information to your webhook endpoint at `event_url`.

To handle inbound calls with the Voice API:

1. [Create a Nexmo application](/concepts/guides/applications#apps_quickstart).

    > **Note**: `answer_url` in the application you created points to a static Conversation NCCO.

2. Create the NCCOs for the business logic you are implementing in your Voice app:

    ```tabbed_content
    source: '_examples/voice/guides/inbound-calls/ncco'
    ```

3. Create the webhook that returns the NCCO for your Conversation. The code examples show how to create a private communication system where you connect an inbound call to a hidden outbound phone number:

    ```tabbed_examples
    source: '_examples/voice/guides/inbound-calls/webhook'
    ```

4. Handle the call state changes at <i>event_url</i>. To inspect and debug state changes without writing your own server, create an online endpoint service such as [requestb.in](http://requestb.in/) or [https://hookbin.com/](https://hookbin.com/). The following code examples show you how to handle changes in Conversation state:

    ```tabbed_examples
    source: '_examples/voice/guides/inbound-calls/handle-the-call-state-changes'
    ```

5. Your Conversation starts when somebody calls the virtual number associated with the application.
