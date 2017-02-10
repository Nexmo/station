---
title: Alerts
---

# Alerts

You use Event Based Alerts to communicate with people using Event Based Alerts. Provision a US Short Code with a standard or custom template that specifies the custom parameters for Alert messages.

> Note: quality of delivery (QoD) statistics are based on delivery receipts (DLR). For the US we only receive intermediate and not handset DLRs. This means Dashboard analytics cannot show QoD statistics for short codes.

## Sending Alerts

You use Event Based Alerts to send custom messages to your users. Before you use this API you have to [Setup a Pre-approved Short Code for Event Based Alerts](tools/dashboard#event_based_alerts)

The workflow for sending Event Based Alerts is:

![Event Based Alerts Workflow](/assets/images/workflow_sending_event_based_alerts.svg)

1. Send an Event Based Alerts [request](messaging/us-short-codes-api/event-based-alerts/send-event-based-alerts/api-reference#request).

2. Check the [response codes](messaging/us-short-codes-api/event-based-alerts/send-event-based-alerts/api-reference#status-codes) in the [response](messaging/us-short-codes-api/event-based-alerts/send-event-based-alerts/api-reference#response) and ensure that  you sent the request to Nexmo correctly.

3. Nexmo sends the alert to your user.

4. Receive the [delivery receipt](messaging/us-short-codes-api/two-factor-authentication/api-reference#delivery-receipt) at your [webhook endpoint](messaging/setup-callbacks) and verify delivery.


### Implementing the Event Based Alerts workflow

To send Event Based Alerts to your users:

1. Send an Event Based Alerts [request](messaging/us-short-codes-api/event-based-alerts/send-event-based-alerts/api-reference#request). If you have multiple templates, remember to set the <i>template</i> number in your request.

    ```tabbed_examples
    source: '_examples/messaging/us-short-codes-api/alerts/send-alerts-request'
    ```

2. Check the [response codes](messaging/us-short-codes-api/event-based-alerts/send-event-based-alerts/api-reference#status-codes) in the [response](messaging/us-short-codes-api/event-based-alerts/send-event-based-alerts/api-reference#response) and ensure that you sent the request to Nexmo correctly:

    ```tabbed_examples
    source: '_examples/messaging/us-short-codes-api/generic/check-the-response-codes'
    ```

3. Nexmo sends the alert to your user.

4. Receive the [delivery receipt](messaging/us-short-codes-api/event-based-alerts/send-event-based-alerts/api-reference#delivery_receipt) at your [webhook endpoint](messaging/setup-callbacks) so you can see:

    1. If the [status](messaging/us-short-codes-api/event-based-alerts/send-event-based-alerts/api-reference#dlr_status) was `delivered`.

    2. When and how the message was made.

    3. How much the message cost.

    ```tabbed_examples
    source: '_examples/messaging/us-short-codes-api/generic/delivery-receipt'
    ```

> Note: remember to send return *200 ok* when you receive the delivery receipt.
