Title: API reference

----

Text:

#API reference

This defines Event Based Alerts API:
* (link: #request text: Request) - send an Event Based Alert to you user.  If you have multiple templates, remember to set the *template* number in your request.
* (link: #response text: Response) - Check the (link: #status-codes text: response codes) to ensure that  you sent the request to Nexmo correctly.
* (link: #delivery_receipt text: Delivery receipt) - verify that the Event Based Alert was delivered.

<a name="request"></a>
##Request

Before calling this API, you need to configure your message in Nexmo (link: @app.root@ text: Dashboard). A message template normally contains custom parameters that you supply in your request.

A basic Short Code Event Based Alert *request* looks like:

``https://rest.nexmo.com/sc/us/alert/json?api_key=xxxxxxxx&api_secret=xxxxxxxx&to=xxxxxxxxxxxx``

If you have a template in the form:
``Your ${server} is down, for more details check ${link}``
Your request will be:
``https://rest.nexmo.com/sc/us/alert/json?api_key=xxxxxxxx&api_secret=xxxxxxxx&to=xxxxxxxxxxxx&server=host3&link=https://example.com/host3/mon``

This request contains:
* A (link: #base text: Base URL)
* (link: #parameters  text: Parameters)
* (link: #authentic  text: Authentication information)
* (link: #security  text: Security)
* (link: #encode text: Encoding)

<a name="base"></a>
###Base URL
All requests to the Shortcode Event Based Alert API must contain:
* `https://rest.nexmo.com/sc/us/alert`
* A response object: *json* or *xml*

Your base URL becomes either:

|JSON|XML
|----|---
| `https://rest.nexmo.com/sc/us/alert/json`| `https://rest.nexmo.com/sc/us/alert/xml`


<a name="parameters"></a>
### Parameters
The following table shows the parameters you use in the request:

Parameter | Description | Required
-- | -- | --
to  | The single phone number to send *pin* to.  Mobile number in <strong>US format</strong> and one recipient per request. For example, to=16365553226. | Yes
<span style="white-space:nowrap;">status-report-req</span> | Set to `1` to receive a (link: #delivery_receipt text: delivery receipt). To receive the delivery receipt, you have to configure a webhook endpoint in Dashboard. | No
<a name="client-ref"></a>client-ref | A 40 character reference string for your internal reporting. | No
template | If you have multiple templates, this is the index of the template to call. The default template starts is 0, each Event Based Alert campaign can have up to 6 templates.<br/>If you have one template only it is the default. That is, *template=0*. If you create a request with *template=1* the API call will default, *template=0*  instead. After you add a valid campaign alert for 2FA, the request will call template 1 instead of template 0. | No
type | Default value is *text*. Possible values are: <ul><li>text - for plain text SMS.</li><li>unicode - SMS in <a href="https://en.wikipedia.org/wiki/unicode" target="_blank">unicode</a>. Only use *unicode* when your SMS must contain special characters.</li></ul>| No.
custom | Any custom parameters you need for *template*. | No

(security: somevalue)

(smsapi_response: somevalue)

(smsapi_dlr: somevalue )


----
Description:

Reference guide for Event Based Alerts.
