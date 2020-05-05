---
title: Overview
meta_title: Redact your data to stay GDPR compliant
---

# Redact your data

Nexmo provides two solutions to cover your compliance and privacy needs. The Auto-redact service and the Redact API allow you to redact sensitive/personal information either automatically or on demand from our platform.

## Contents

In this document you can learn about:

* [Nexmo Redact Concepts](#concepts)
* [Right to erasure requests](#right-to-erasure-requests)
* [Subject Access Requests](#subject-access-requests)
* [Technical Support Impact](#technical-support-impact)

## Concepts

There are three ways that you can redact personal information from the Nexmo platform:
* Auto-redact service
* Redact API
* General product APIs
Each of these options has a different use case and an interaction model.

### Stored data and redaction

When you use Nexmo communication APIs, we create server logs and transactional records of the activity, which we call a `CDRs` (short for `call detail record`, a telecommunication industry term). Server logs are retained for ~15 days (at most one month) but the CDRs are stored for 13 months. Both server logs and CDRs can be viewed by our support staff for various purposes, including testing and debugging, diagnosing user issues, and reconciling CDRs against customer's transaction records.

The Auto-redact service and the Redact API can be used to remove Personal Identifiable Information (PII) stored in the Nexmo platform. PII held in the platform generally includes the receiver phone number for outbound messages/calls and sender phone number for inbound messages/calls. For messages, PII also icludes the message content. In terms of PII, server logs and CDRs are identical, i.e. they contain exactly the same PII.

Upon redaction, the real PII content in the redacted fields is overwritten with the string "REDACTED". Redaction of the receiver/sender phone number is subject to applicable data retention regulations, which are country-specific. Details are provided in the following sections.

Customers can view the redacted CDRs using either the [Reports API](/api/reports) or the Customer Dashboard.


### Auto-redact service

Nexmo provides the Auto-redact service that automatically redacts PII from the Nexmo systems without any actions from your side. You can define whether you want redaction to be done immediately (once the message/call has been processed) or with a delay of several days. Supported values are 15 and 30 days. The scope of redaction and the configurable delay depends on which of the Nexmo communication APIs you are using. Some communication APIs support Standard Auto-redact while other support Advanced Auto-redact. Standard Auto-redact, like the Free Redact API, cannot redact server logs. It redacts only CDRs. Advanced Auto-redact redacts both the CDRs and the server logs. The detailed description is provided in the following paragraphs.

Please find a relevant pricing for the auto-redact service here: [Nexmo Prices](https://www.vonage.com/communications-apis/pricing/)

To request enablement of the Auto-redact service for your account, please visit [this page](https://info.nexmo.com/RedactAPI.html).


### Redact API

The Redact API provides Nexmo customers with an endpoint to programmatically request the redaction of CDRs (retained for 13 months) held in the Nexmo platform. Redact API does not have the capability to redact the server logs (retained for ~15 days).

To use the Redact API, you have to provide transaction (message/call) IDs returned in the responses to the API requests sent by you to the Nexmo communication APIs. For each ID, you need to make a request to the [Nexmo Redact API](/api/redact).

It is not possible to make the redaction API request immediately after receiving the transaction ID because it takes time (up to several minutes) for the CDRs to propogate to the long-term storage that Redact API redacts from. Thus, you either have to save in your database the returned transaction (CDR) IDs for later reference or use the Reports API to retrieve the CDRs along with their IDs for your account.

The scope of redaction of the Redact API depends on what Nexmo communication APIs you were using. The detailed description is provided below.

To request access to the Nexmo Redact API, please visit [this page](https://info.nexmo.com/RedactAPI.html)

To learn more about the Redact API please refer to the [Redact API Reference](/api/redact)


### Auto-redact vs Redact API

| Features | Redact API | Auto-redact Standard | Auto-redact Advanced |
| --------------- | --------------- | --------------- | --------------- |
| Usage | For each record that you want to redact, you need to know a record  ID and you need to make a request to the [Nexmo Redact API](/api/redact) | Automatic. Does not require any customer intervention | Automatic. Does not require any customer intervention |
| Redaction scope | only CDRs | only CDRs | server logs and CDRs |
| Provisioning | Required | Required | Required |
| Price | Free | Paid | Paid |

### Detailed description of redaction scope per API
#### SMS API
<table>
  <tr>
    <th>API</th>
    <td>SMS</td>
  </tr>
  <tr>
    <th>PII</th>
    <td>PII includes the message content and the receiver phone number for outbound messages and sender phone number for inbound messages.<br> The SMS API uses a data pipeline software to transport CDRs to various databases. The data pipeline keeps CDRs along with receiver/sender phone number for 7 days. Thus, besides server logs and the long-term storage of CDRs, PII is also stored in the data pipeline logs</td>
  </tr>
  <tr>
    <th>Supported Auto-redact type</th>
    <td>Advanced</td>
  </tr>
  <tr>
    <th>Auto-redact details</th>
    <td>Advanced Auto-redact for SMS redacts server logs, CDRs, and the data pipeline logs. The scope of auto-redaction is configurable and can include the following options:<br><ul><li>message content redaction only</li><li>phone number redaction only</li><li>phone number encryption only</li><li>message content redaction together with redaction or encryption of the phone number </li></ul>When immediate message content redaction is configured, message content is not written at all, not even to the server logs.<br> When number redaction is configured, the phone number gets encrypted by the SMS API before it gets written to the server logs and the data pipeline logs. The moment CDRs get propagated to the long-term storage of CDRs, the encrypted number field gets automatically redacted. The logs containing encrypted numbers expire on their own.<br> Neither Support nor any other personel have access to decryption keys</td>
  </tr>
  <tr>
    <th>Redact API details</th>
    <td>Redact API redacts only the CDRs in the long-term storage of CDRs. The scope of redaction is not configurable and includes message content together with the phone number</td>
  </tr>
</table>

#### Number Insight API
<table>
  <tr>
    <th>API</th>
    <td>Number Insight</td>
  </tr>
  <tr>
    <th>PII</th>
    <td>PII includes the phone number and the phone number owner's details: first name, last name, caller name, and subscriber Id.<br> The NI API uses the data pipeline software to transport CDRs to various databases. The data pipeline keeps logs with PII in them for 7 days. Thus, besides server logs and the long-term storage of CDRs, PII is also stored in the data pipeline logs</td>
  </tr>
  <tr>
    <th>Supported Auto-redact type</th>
    <td>Advanced</td>
  </tr>
  <tr>
    <th>Auto-redact details</th>
    <td>Advanced Auto-redact for NI redacts server logs, CDRs, and the data pipeline logs. The scope of auto-redaction is configurable and can include the following options:<br><ul><li>phone number owner details only</li><li>phone number redaction only</li><li>phone number encryption only</li><li>redaction of phone number owner's details together with redaction or encryption of the phone number</li></ul>When redaction is configured, the content of the redacted fields is not written at all, not even to the server logs. Everything gets redacted immediatly (if redaction delay is set to zero).</td>
  </tr>
  <tr>
    <th>Redact API details</th>
    <td>Redact API redacts only the CDRs in the long-term storage of CDRs. The scope of redaction is not configurable and includes the phone number and the phone number owner's details</td>
  </tr>
</table>


#### Messages API
<table>
  <tr>
    <th>API</th>
    <td>Messages API</td>
  </tr>
  <tr>
    <th>PII</th>
    <td>PII includes the message content and the receiver phone number for outbound messages and sender phone number for inbound messages.<br> The Messages API uses a data pipeline software to transport CDRs to various databases. The data pipeline keeps CDRs along with receiver/sender phone number for 7 days. Thus, besides server logs and the long-term storage of CDRs, PII is also stored in the data pipeline logs</td>
  </tr>
  <tr>
    <th>Supported Auto-redact type</th>
    <td>Standard</td>
  </tr>
  <tr>
    <th>Auto-redact details</th>
    <td>Standard Auto-redact for the Messages API redacts only CDRs in the long-term storage of CDRs. The scope of auto-redaction is configurable and can include the following options:<br><ul><li>message content redaction only</li><li>phone number redaction only</li><li>message content and phone number redaction</li></ul></td>
  </tr>
  <tr>
    <th>Redact API details</th>
    <td>Redact API redacts only CDRs in the long-term storage of CDRs. The scope of redaction is not configurable and includes the phone number and the phone number owner's details</td>
  </tr>
</table>


#### Voice API

When you use the Voice API to make calls, one or more call resources will be created, as well as call detail records (CDRs). While you can use the Auto-redact service or the Redact API to remove personal data (in this case, the phone number) from the CDR, the call resources themselves will continue to exist.

Call resources are stored as "legs". For instance, if a proxy call is set up between a virtual number V and two other phone numbers A and B, there will be two legs, one between A and V, and one between B and V. These will exist as two separate leg resources with their own unique identifiers.

To determine the identifiers of the leg resources, use the [GET method](/api/conversation#listLegs) and add a query parameter to filter by the `conversationUuid` of the call.

Once the identifiers are known, each leg resource can be deleted with the [DELETE method](/api/conversation#deleteLeg).

For voice applications where a call recording is made, e.g. using the [record action](/voice/voice-api/ncco-reference#record) of an NCCO, a media resource will be created which holds the recording. This can be deleted using the `DELETE` method of the [Media API](/api/media#delete-a-media-item).

<table>
  <tr>
    <th>API</th>
    <td>Voice API</td>
  </tr>
  <tr>
    <th>PII</th>
    <td>PII includes the receiver phone number for outbound calls and the sender phone number for inbound calls. If the phone recording functionality is used, the recorded audio files are also consider as PII.</td>
  </tr>
  <tr>
    <th>Supported Auto-redact type</th>
    <td>Standard</td>
  </tr>
  <tr>
    <th>Auto-redact details</th>
    <td>Standard Auto-redact for the Voice API redacts only CDRs in the long-term storage of CDRs. The scope of redaction is not configurable and includes only the phone number</td>
  </tr>
  <tr>
    <th>Redact API details</th>
    <td>Redact API redacts only CDRs in the long-term storage of CDRs. The scope of redaction is not configurable and includes only the phone number</td>
  </tr>
</table>


#### Nexmo Conversations API

For the multi-channel communications APIs of Conversation, a developer might decide to use personal data (such as a personal phone number) as a user handle. In that case, the [PUT method](/api/conversation#updateUser) of the User resource could be used to replace the personal data in the resource, or the [DELETE method](/api/conversation#deleteUser) could be used to simply delete the resource completely.

If Conversation messages need to be redacted, the corresponding Event resource can be deleted using the [DELETE method](/api/conversation#deleteEvent).

Note that when a Conversation resource is deleted, it will no longer be available to query via a GET API call. If you need this information, you must store it in your own system/database outside of the Nexmo platform.


## Right to erasure requests

Under GDPR (and other privacy laws and regulations), a person may ask you to remove any data being held about them. This could typically happen when someone terminates their relationship with a vendor, e.g. the user of a dating app no longer needs the service, and asks the dating app vendor to delete their account and all the information it holds about them.

## Subject Access Requests

Under GDPR, your customers can come to you and ask for the information that you hold on them. While each organization will need to determine the appropriate way to implement their request process, Nexmo can help by providing data about what information is held in the platform, if necessary.

Data held on an individual by Nexmo can be obtained using the following methods:

* Customer dashboard
* Reports API

Each of these options is described in more detail in the following sections.

### Customer Dashboard

In the Nexmo Customer Dashboard, it is possible to search for records via a user interface. Generally, searches can be by:

* transaction ID, e.g. find details of a single SMS by providing the message-id
* phone number and date, e.g. find all SMS sent to a specific phone number on a specific date
* date range, e.g. download all messages (up to a limit of 4000) sent between two specific dates

This method might be appropriate if generally very few or only a single message would ever be sent to a single person.

Using the dashboard, you can search for [SMS messages](https://dashboard.nexmo.com/sms), [voice calls](https://dashboard.nexmo.com/voice/search), [Verify requests](https://dashboard.nexmo.com/verify) and [Number Insight requests](https://dashboard.nexmo.com/number-insight).

### Reports API

[Reports API](https://developer.nexmo.com/reports/overview) can be used to search for all kinds of data records for all types of communication APIs in bulk. It has two relevant modes:

* Retrieve a JSON record describing an individual single message/call. It can be queried using the [load records endpoint](https://developer.nexmo.com/api/reports#get-records)

* Retrieve multiple data records simultaneously. This can be done either by providing a date range to the [load records endpoint](https://developer.nexmo.com/api/reports#get-records) or by creating a CSV report containing all records with the help of the [create report endpoint](https://developer.nexmo.com/api/reports#create-async-report).

To learn about how to use Reports API please refer to the [Reports API tutorials](https://developer.nexmo.com/reports/overview)

## Technical Support Impact

Please be aware that redaction of identifying data can have a negative impact on our ability to troubleshoot customer-specific service degradations. As part of our commitment to our customers' success, Nexmo Support will attempt to provide assistance to all customers wherever possible. Typically diagnosis of an issue would start with attempting to identify a specific problematic API call or communication event relating to this issue, or a pattern of related events (messages or calls).

If your system does not log the responses you receive from the Nexmo API (for instance storing the transaction ID and details in a database table or a text file), or it is difficult to access this response data, it is common to identify the transaction relating to an issue via a related phone number or message text body. Examples could include:

* the 'to' phone number for an outbound SMS to the phone of one of your users
* the 'from' phone number for an inbound call to your Nexmo virtual number

If you need to redact a phone number because one of your users has asked to delete their account and data, you can use the Redact API to do this as described above. This means that we will remove the phone number from all of our communications records (also known as "CDRs") in our system.

The side effect of this is that if you want to diagnose an issue with one of these communications events, you will not be able to ask us to help by only providing the phone number; you will instead need to provide the relevant transaction ID or IDs that were been provided in your initial communications API response. e.g. for SMS, the 'message-id' value. You will therefore need to make sure that if you need to ask for Nexmo Support help relating to the transaction, it is essential that you have saved and can find the transaction ID.

We would also be unable to detect an issue based on differential analysis  of a pattern of communications to a single number or range of numbers, such as failed versus successful transactions over time.

Keep in mind that if you have already deleted one of your users and their data from your system, it is probably unlikely that you will need to address a complaint from that user that they did not receive a message or they had a problem with a call.

Note that all communications records containing phone numbers are deleted after thirteen months, so we will not be able to help you diagnose an issue with a communications transaction older than this.
