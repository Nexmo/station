---
title: API reference
description: Reference guide for the Media API
api: Media API
---

# API Reference 

The Media API allows you to manage media files associated with your account and its applications. Authorisation is done using a [JSON Web Token](/concepts/guides/authentication#json-web-tokens-jwt) (JWT) in the `Authorization` header.

## Upload media

[POST] `https://api.nexmo.com/v3/media`

This endpoint is used to upload media files (usually audio) to the media service. Upon successful upload, you will get back a response with status 201 giving you a URL pointing to the metadata for the media file.

The media file will be associated with both your account _and_ the Application ID of the JWT you use. This enables you to separate media files out by application.

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

All parameters are optional.

|Name|Description|Type|
|---|---|---|
|`order`|The order of search results: either `ascending` or `descending`.|string|
|`page_index`|Which page to retrieve in pagination.|integer|
|`page_size`|How many items per page.|integer|
|`start_time`|Search criteria: finds media created after this date-time.|string (ISO 8601)|
|`end_time`|Search criteria: finds media created before this point.|string (ISO 8601)|

If no `start_time` and `end_time` are set, the default response will show the last seven days of uploaded files (and a response code of `404`).

### Responses

Successful requests will return a JSON document that follows the conventions of [Hypertext Application Language](http://stateless.co/hal_specification.html) (HAL) with a `Content-Type` of `application/json`.

|HTTP Code|Description|
|---|---|
|200|Successful operation|
|401|Authentication failure|
|403|Authorisation denied|
|404|No such item.|
|500|Internal server error|

A `404` may be returned if no results meet your selection criteria.


## Download media file

[GET] `/v3/media/{media_id}`

You can retrieve media files by GET-ting the URL of the file (making sure to remove the `/info` URL suffix).

This endpoint is able to conditionally return media files based on the `If-Modified-Since` and `If-None-Match` headers as defined in HTTP (see [Wikipedia: List of HTTP header fields](https://en.wikipedia.org/wiki/List_of_HTTP_header_fields)).

If the `If-Modified-Since` header is set, the server will return the media file if and only if the content of the file has changed since the date-time specified in the header (in ISO 8601-style format).

If the `If-None-Match` header is set, the server will return the media if and only if the content of the file's ETag is _not_ the same as the one sent in.

Using the `If-Modified-Since` or `If-None-Match` headers allows you to efficiently cache content you have downloaded from the Media API and only transfer the data from our servers if the data has been modified.

We recommend that you should use the `If-None-Match` approach for caching files based on their content.

The `Range` header is supported and allows you to specify which bytes of the file you wish to receive.

If the `publicItem` property in the file's properties is set to `true`, downloading from this endpoint requires no authentication. If it is set to `false`, you will need to authenticate your request using your application's JSON Web Token in the `Authorization` header.

The number of times a file can be downloaded is determined by the `maxDownloadsAllowed` property of the file's metadata. If the total number of downloads exceeds that number, you will not be able to download the file unauthenticated. If our request is authenticated with a JSON Web Token, you will be allowed to download the file even if doing so exceeds the `maxDownloadsAllowed` limit.

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

Deletes the media file. This API call must be authenticated using the JWT of the application the media file is associated to (as appropriate).

### Responses

|HTTP Code|Description|
|---|---|
|204|Media item deleted|No Content|
|401|Authentication failure|No Content|
|403|Authorisation denied|No Content|
|404|No such item|No Content|
|500|Internal server error|No Content|


## Get media file metadata

[GET] `https://api.nexmo.com/v3/media/{media_id}/info`

Authentication can be done using using a JSON Web Token for the application the media is associated with.

### Responses

|HTTP Code|Description|
|---|---|
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
|`maxDownloadsAllowed`|The maximum number of times the file may be downloaded.|
|`timesDownloaded`|The number of times the file has been downloaded.|
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

You must authenticate using a JSON Web Token signed using the application's private key.

### Request body

The metadata you can update is listed below:

|Name|Description|Type|Required|
|----|-----------|----|--------|
|`publicItem`|Whether the item is publicly available without authentication.|boolean|
|`metadataPrimary`|A string (which can be JSON encoded) containing metadata about the media file.|string|
|`metadataSecondary`|A string (which can be JSON encoded) containing further metadata about the media file.|string|
|`title`|A string containing a title for the media file.|string|
|`description`|A description of the media file.|string|
|`mimeType`|The MIME type of the media file.|string|
|`maxDownloadsAllowed`|The maximum number of times the file may be downloaded.|integer|

### Responses

|HTTP Code|Description|Body|
|---|---|---|
|200|OK (Data updated)|No Content|
|401|Authentication failure|No Content|
|403|Authorisation denied|No Content|
|404|No such item|No Content|
|500|Internal server error|No Content|

