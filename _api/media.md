---
title: API reference
description: Reference guide for the Media API
api: Media API
---

# API Reference 

The Media API allows you to manage media files associated with your account and its applications. You can authenticate either using your API keys (as query string parameters: `api_key` and `api_secret`) or using a JSON Web Token (JWT) in the `Authorization` header.

## Upload media

[POST] `https://api.nexmo.com/v3/media`

This endpoint is used to upload media files (usually audio) to the media service. Upon successful upload, you will get back an `application/json` document with status 201 giving you an identifier for the media file.

If you authenticate with an application-based JSON Web Token (JWT), the media file will be associated with both your account _and_ the Application ID of the JWT you use.

### Request

Requests to this endpoint should be `multipart/form-data`.

The following parameters can be passed in as form data in addition to the file.

|Name|Type|Description|Required|
|---|---|---|---|
|`filename`| string | An optional name for the file. | ❎
|`info`| string (usually JSON object) | Any metadata you wish to associate with the file. | ❎
|`url`| string (URL) | This can be provided as an alternative to the file data. We will download the file from this URL. This will be stored in `sourceUrl`. | ❎


### Response

If the media item has uploaded without error, you will get a `201` status code. The `Location` header will provide a URL for your file.

If there was a problem with either your request or with the server, you will get an error status code. The body of the response may provide more details about the error as a JSON document.

|HTTP Code|Description|
|---|---|
|201|Media item created|
|401|Authentication failure|
|403|Authorisation denied|
|404|No such item|
|500|Internal server error|

The URL returned on `201` will be suffixed with `/info` like this: 

> `https://api.nexmo.com/v3/media/aaaaaaaa-0000-aaaa-0000-aaaaaaaaaaaa/info`

If you remove the `/info` from the Location response header, the resulting URL allows you to retrieve the media file itself.

## Search media files

[GET] `https://api.nexmo.com/v3/media`

### Parameters

|Name|Description|Schema|Default|
|---|---|---|---|
|`api_key`  <br>*optional*|Username for password-based login|string||
|`api_secret`  <br>*optional*|Password for password-based login|string|`"secret1"`|
|`end_time`  <br>*optional*||string||
|`metadata_primary`  <br>*optional*||string||
|`metadata_secondary`  <br>*optional*||string||
|`order`  <br>*optional*||string||
|`page_index`  <br>*optional*||integer (int32)||
|`page_size`  <br>*optional*||integer (int32)||
|`start_time`  <br>*optional*||string||


### Responses

Successful requests will return a JSON document that follows the conventions of [Hypertext Application Language](http://stateless.co/hal_specification.html) (HAL) with a `Content-Type` of `application/json`.

|HTTP Code|Description|
|---|---|
|200|Successful operation|
|401|Authentication failure|
|403|Authorisation denied|
|404|No such item|
|500|Internal server error|


## Download media file

[GET] `/v3/media/{media_id}`

You can retrieve media files by GET-ting the URL of the file (making sure to remove the `/info` URL suffix).

This endpoint is able to conditionally return media files based on the `If-Modified-Since` and `If-None-Match` headers as defined in HTTP (see [Wikipedia: List of HTTP header fields](https://en.wikipedia.org/wiki/List_of_HTTP_header_fields)).

If the `If-Modified-Since` header is set, the server will return the media file if and only if the content of the file has changed since the date-time specified in the header (in ISO 8601-style format).

If the `If-None-Match` header is set, the server will return the media if and only if the content of the file's ETag is _not_ the same as the one sent in.

Using the `If-Modified-Since` or `If-None-Match` headers allows you to efficiently cache content you have downloaded from the Media API and only transfer the data from our servers if the data has been modified.

The `Range` header is supported and allows you to specify which bytes of the file you wish to receive.

If the `publicItem` property in the file's properties is set to `true`, downloading from this endpoint requires no authentication. If it is set to `false`, you will need to authenticate your request using either API keys (by setting `api_key` and `api_secret` as query parameters) or by sending your application's JSON Web Token in the `Authorization` header.


### Parameters

|Name|Description|Type|Required|
|---|---|---|---|
|`api_key`|API key of your account. Only required if the media item's `publicItem` property is false.|string|❎|
|`api_secret`|API secret of your account. Only required if the media item's `publicItem` property is false.|string|❎|


### Responses

|HTTP Code|Description|
|---|---|
|200|Successful operation|The data contained in the item.|
|304|Not modified|If the media item matches the `If-Modified-Since` or `If-None-Match` header (see above), this is returned.|
|401|Authentication failure|No Content|
|403|Authorisation denied|No Content|
|404|No such item|No Content|
|500|Internal server error|No Content|


## Delete media file

[DELETE] `https://api.nexmo.com/v3/media/{media_id}`

Deletes the media file. This API call must be authenticated using your API key and secret or the JWT of the application the media file is associated to (as appropriate).

### Parameters

|Name|Description|Type|
|---|---|---|---|
|`api_key`|API key of your account.|string|
|`api_secret`|API secret of your account|string|


### Responses

|HTTP Code|Description|Schema|
|---|---|---|
|204|Media item deleted|No Content|
|401|Authentication failure|No Content|
|403|Authorisation denied|No Content|
|404|No such item|No Content|
|500|Internal server error|No Content|


## Get media file metadata

[GET] `https://api.nexmo.com/v3/media/{media_id}/info`

Authentication can be done using either API keys and secrets or using a JSON Web Token for the application the media is assocaited with.

### Parameters

|Name|Description|Type|
|---|---|---|---|---|
|`api_key`|Your API key|string|
|`api_secret`||Your API secret|string|


### Responses

|HTTP Code|Description|
|---|---|---|
|`200`|successful operation|
|`401`|Authentication failure|
|`403`|Authorisation denied|
|`404`|No such item|
|`500`|Internal server error|

### Keys and values

|Key|Description|
|---|-----------|
|`id`|A UUID representing the object.|
|`originalFileName`|The filename of the object as it was originally uploaded.|
|`mimeType`|The IETF MIME type of the file.|
|`accountId`|The ID of your Nexmo account. This is the same as your API key.|
|`storeId`|An internal identifier of how the file is stored.|
|`storeMetaParams`|A JSON encoded string containing metadata about the file.|
|`maxDownloadsAllowed`|Reserved for future use.|
|`timesDownloaded`|Reserved for future use.|
|`etag`|An identifier for the content. This will change if the content of the file has been changed (i.e. if you upload a new version of the file). For more information see [Wikipedia: HTTP ETag](https://en.wikipedia.org/wiki/HTTP_ETag)|
|`mediaSize`|The size of the file in bytes.|
|`metadataPrimary`|A string (which may be JSON encoded) to store metadata associated with the file.|
|`metadataSecondary`|A string (which may be JSON encoded) to store metadata associated with the file.|
|`timeCreated`|The time the file was created in milliseconds since epoch (1970-01-01).|
|`timeLastUpdated`|The time the file was last modified in milliseconds since epoch (1970-01-01).|
|`publicItem`|Whether the item is available for download without authentication.|
|`sourceUrl`|If the file was copied from a URL, the URL will be here.|


### Example response

````json
{
  "id": "aaaaaaaa-0000-aaaa-0000-aaaaaaaaaaaa",
  "originalFileName": "test.wav",
  "mimeType": "audio/wav",
  "accountId": "aaaaaa01",
  "storeId": "s3-enc",
  "storeMetaParams": "{\"filesize\":\"1024\"}",
  "maxDownloadsAllowed": 0,
  "timesDownloaded": 0,
  "etag": "6f5902ac237024bdd0c176cb93063dc4",
  "mediaSize": 1024,
  "timeCreated": 1502818392405,
  "timeLastUpdated": 1502818392405,
  "publicItem": false
}
````

## Update media file metadata

[PUT] `https://api.nexmo.com/v3/media/{media_id}/info`

You can update a number of components of the media item's metadata. To do this, PUT a JSON object (with `Content-Type` of `application/json`) to the same URL as used to [retrieve data about it](#get-media-file-metadata) with the relevant keys.

If the file is associated with an application, you must authenticate using a JSON Web Token signed using that application's private key. If the file is not associated with an application, you must authenticate using your API key and secret.

### Parameters

|Name|Description|Type|Required|
|---|---|---|---|
|`api_key`|API key of your account.|string|✓|
|`api_secret`|API secret of your account.|string|✓|


### Responses

|HTTP Code|Description|Body|
|---|---|---|
|200|OK (Data updated)|No Content|
|401|Authentication failure|No Content|
|403|Authorisation denied|No Content|
|404|No such item|No Content|
|500|Internal server error|No Content|

<!--
## Definitions

## MediaItem

|Name|Schema|
|---|---|
|`accountId`  <br>*optional*|string|
|`applicationId`  <br>*optional*|string|
|`description`  <br>*optional*|string|
|`endOfLife`  <br>*optional*|string (date-time)|
|`etag`  <br>*optional*|string|
|`id`  <br>*optional*|string|
|`lastDownloaded`  <br>*optional*|string (date-time)|
|`maxDownloadsAllowed`  <br>*optional*|integer (int32)|
|`mediaSize`  <br>*optional*|integer (int64)|
|`metadataPrimary`  <br>*optional*|string|
|`metadataSecondary`  <br>*optional*|string|
|`mimeType`  <br>*optional*|string|
|`originalFileName`  <br>*optional*|string|
|`path`  <br>*optional*|string|
|`publicItem`  <br>*optional*|boolean|
|`requiresPinCode`  <br>*optional*|string|
|`sourceUrl`  <br>*optional*|string|
|`storeId`  <br>*optional*|string|
|`storeMetaParams`  <br>*optional*|string|
|`timeCreated`  <br>*optional*|string (date-time)|
|`timeLastUpdated`  <br>*optional*|string (date-time)|
|`timesDownloaded`  <br>*optional*|integer (int32)|
|`title`  <br>*optional*|string|


### MediaParameters

|Name|Schema|
|---|---|
|`description`  <br>*optional*|string|
|`maxDownloadsAllowed`  <br>*optional*|integer (int32)|
|`metadataPrimary`  <br>*optional*|string|
|`metadataSecondary`  <br>*optional*|string|
|`mimeType`  <br>*optional*|string|
|`publicItem`  <br>*optional*|boolean|
|`requiresPinCode`  <br>*optional*|string|
|`title`  <br>*optional*|string|
|`ttl`  <br>*optional*|integer (int32)|


### OutputStream

*Type* : object


### PageLinks

|Name|Schema|
|---|---|
|`first`  <br>*optional*|[HrefLink](#hreflink)|
|`last`  <br>*optional*|[HrefLink](#hreflink)|
|`next`  <br>*optional*|[HrefLink](#hreflink)|
|`prev`  <br>*optional*|[HrefLink](#hreflink)|
|`self`  <br>*optional*|[HrefLink](#hreflink)|


### ResultPageHAL

|Name|Schema|
|---|---|
|`_embedded`  <br>*optional*|< string, < object > array > map|
|`_links`  <br>*optional*|[PageLinks](#pagelinks)|
|`count`  <br>*optional*  <br>*read-only*|integer (int64)|
|`page_index`  <br>*optional*  <br>*read-only*|integer (int64)|
|`page_size`  <br>*optional*  <br>*read-only*|integer (int32)|

-->
