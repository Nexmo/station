# API reference

## Contents

* [Security and Authentication](#authentication)
* [Encoding](#encoding)
* [Conversations](#conversations):
  * [POST `https://api.nexmo.com/beta/conversations`](#conversations_post)
  * [GET `https://api.nexmo.com/beta/conversations?{query}`](#conversations_get_query)
  * [GET `https://api.nexmo.com/beta/conversations/{uuid}`](#conversations_get_single)
  * [PUT `https://api.nexmo.com/beta/conversations`](#conversations_put)
  * [DELETE `https://api.nexmo.com/beta/conversations`](#conversations_delete)
* [Users](#users):
  * [POST `https://api.nexmo.com/beta/users`](#users)
  * [GET `https://api.nexmo.com/beta/users?{query}`](#users_get_query)
  * [GET `https://api.nexmo.com/beta/users/{uuid}`](#users_get_single)
  * [PUT `https://api.nexmo.com/beta/users`](#userss_put)
  * [DELETE `https://api.nexmo.com/beta/users`](#users_delete)
* [Members](#members):
  * [POST `https://api.nexmo.com/beta/conversations/{uuid}/members`](#members_post)
  * [GET `https://api.nexmo.com/beta/conversations/{uuid}/members`](#members_get)
  * [PUT `https://api.nexmo.com/beta/conversations/{uuid}/members`](#members_put)
  * [DELETE `https://api.nexmo.com/beta/conversations/{uuid}/members`](#members_delete)
* [Webhooks](#conversations_webhooks)
  * [Conversation Event](#conversations__event_webhook) - ???
* [Errors](#errors)

<a name="authentication"></a>
## Security and Authentication

You authenticate requests with the Conversation API using JSON Web Tokens (JWT).

A JWT consists of a header, a payload and a signature in the structure xxxxx.yyyyy.zzzzz. The expected JWT structure is as follows prior to signing is:

```json
{
  "alg": "RS256", // The encryption algorithm used to generete the JWT. RS256 is supported.
  "typ": "JWT", // The media type of the JWT. JWT is supported.
  "iat": 1499960490, // The UNIX timestamp at UTC + 0 indicating the moment the JWT was issued.
  "jti": "bd620670-67e1-11e7-b2ab-39affcc8ac9c", // The unique ID of the JWT.
  "sub": "jamie", // Optional. The name for the User you are trying to authenticate.
  "exp": "1500046889", // Optional. The UNIX timestamp at UTC + 0 indicating the moment the JWT is no longer valid. Default to 15 minutes from the time the JWT was issued.
  "acl": {  // Access control list
    "paths": { // The API paths and related permissions that the JWT has
      "/v1/sessions/**": {},
      "/v1/users/**": {},
      "/v1/conversations/**": {}
    }
  },
  "application_id": "YOUR_APP_ID" // Your Nexmo application UUID
}
```

You must use HTTPS for all Nexmo API requests.

<a name="encoding"></a>
## Encoding

You submit all requests with a `POST`, `PUT` or `GET` HTTP request using UTF-8 encoding and URL encoded values. The expected `Content-Type` for `POST` or `PUT` should be `application/json`

<a name="conversations"></a>
## Conversations

You use the following requests to create, read, update and delete Conversations:

* [POST `https://api.nexmo.com/beta/conversations`](#conversations_post) - create a Conversation
* [GET `https://api.nexmo.com/beta/conversations?`](#conversations_get_query) - query Conversations
* [GET `https://api.nexmo.com/beta/conversations/UUID`](#conversations_get_single) - get information about a single Conversation
* [PUT `https://api.nexmo.com/beta/conversations`](#conversations_post) - modify an existing conversation
* [DELETE `https://api.nexmo.com/beta/conversations`](#conversations_delete) - delete a conversation

<a name="conversations_create"></a>
### POST
`https://api.nexmo.com/v1/conversations`

Create a Conversation

```
POST /beta/conversations
Host: api.nexmo.com
Content-Type: application/json
Authorization: Bearer {JWT}

{JSON BODY}
```

The request should have a JSON body. The following table shows the parameters you use to create a Conversation:

| Parameter | Description | Required |
| --- | --- | --- |
| name | a unique name for the Conversation | Yes |
| display_name | a Conversation name to be displayed to application users | No. If not supplied the `display_name` will default to the value provided in `name`. |

##### Example JSON body

```json
{
  "name":"nexmo-chat",
  "display_name": "Nexmo Chat"
}
```

#### Response

A successeful request will result in a `201` response with the following attributes.

| Key | Value |
| --- | --- |
| id  |  The unique identifier for the conversation that has been created **TODO: This should be `uuid` to be consistent with VAPI** |
| href | The link for the resources. |

**TODOs**

* `id` should be `uuid` to be consistent with VAPI
* `name` should be present as we have it for the resource
* `display_name` should be present as we have it for the resource
* `href` should be replaced with a HAL+JSON representation e.g.
  ```json
    "_links": {
      "self": {
        "href": "/conversations/63f61863-4a51-4f6b-86e1-46edebcf9356"
      }
    }
  ```

#### Example: Creating a Conversation

```bash
$ curl -X POST https://api.nexmo.com/beta/conversations \
 -H 'Authorization: Bearer JWT \
 -H 'Content-Type:application/json' \
 -d '{"name":"nexmo-chat", "display_name": "Nexmo Chat"}'
```

##### Response

```json
{
  "id": "CON-8cda4c2d-9a7d-42ff-b695-ec4124dfcc38",
  "href" :"https://api.nexmo.com/beta/conversations/CON-8cda4c2d-9a7d-42ff-b695-ec4124dfcc38"
}
```

**TODO**

Structure should be:

```json
{
  "uuid": "CON-8cda4c2d-9a7d-42ff-b695-ec4124dfcc38",
  "name": "nexmo-chat",
  "display_name": "Nexmo Chat",
  "_links": {
    "self": {
      "href": "/conversations/CON-8cda4c2d-9a7d-42ff-b695-ec4124dfcc38"
    }
  }
}
```

<a name="conversations_get_query"></a>

### GET
`https://api.nexmo.com/beta/conversations?{query}`

You use a GET request to query Conversations within your Nexmo application or retrieve all Conversations.

```
GET /beta/conversations?{query}
Host: api.nexmo.com
Content-Type: application/json
Authorization: Bearer {JWT}
```

The following table shows the parameters you use to query Conversations:

| Parameter | Description | Required |
| --- | --- | --- |
| name | The unique human readable name of the conversation | N |

**TODO:** What other parameters can you query on?

#### Response

A successful request results in a `200` response  and contains the following keys and values:

| Key | Value |
| --- | --- |
| count | The number of results for this query |
| page_size | The number of results within this resource. You page through results by changing `record_index` |
| record_index | The index of the query. Default is `0` |
| _links.self.href | The URL for this resource |
| _embedded.conversations | An Array of conversations returned by this query. Each element within the Array will follow the structured outlined in the [single conversation resource](#conversations_get_single) |

#### Example: Retrieving all conversations

```bash
$ curl https://api.nexmo.com/beta/conversations \
 -H 'Authorization: Bearer JWT' \
 -H 'Content-Type:application/json' \
 ```

 **TODO: Executing this fails**

```
 › curl https://api.nexmo.com/beta/conversations -H 'Authorization: Bearer '$APP_JWT
{"code":"conversation:error:db","description":"Internal Error. Missing error type definition: conversation:error:db"}%
```

##### Response

**TODO:** Provide example once all conversations can be returned.

#### Example: Querying conversations:

```bash
curl https://api.nexmo.com/beta/conversations?name=nexmo-chat -H 'Authorization: Bearer '$APP_JWT
```

Response:

```json
{
  "count": 1,
  "page_size": 1,
  "record_index": 0,
  "_links": {
    "self": {
      "href":"/conversations" TODO: missing query string ?name=nexmo-chat
    }
    // TODO: missing next and prev or did we not do that in VAPI?
  },
  "_embedded": {
    "conversations":[
      {
        "uuid":"CON-f5d110db-a937-449c-bb8a-c491954cb2ce",
        "name":"nexmo-chat",
        // TODO: missing display_name
        "_links": {
          "self": {
            "href": "/conversations/CON-f5d110db-a937-449c-bb8a-c491954cb2ce"
          }
        }
      }
    ]
  }
}
```

<a name="conversations_get_single"></a>
### GET by UUID
`https://api.nexmo.com/beta/conversations/{uuid}`

Retrieve information about a single Conversation.

```
GET /beta/conversations/{uuid}
Host: api.nexmo.com
Content-Type: application/json
Authorization: Bearer {JWT}
```

The following table shows the parameters you use when retrieving information about a Conversation:

| Key | Value |
| --- | --- |
| uuid | The universally unique identifier for the conversation to be retrieved |

#### Response

A successful request returns a `200` response with the following keys and values:

| Key | Value |
| --- | --- |
| uuid | The unique identifier |
| name | The human readable unique name |
| display_name | The display name |
| timestamp.created | Time timestamp when the conversation was created |
| sequence_number | TODO |
| numbers | TODO |
| members | An array of users that are members of the conversation |
| api_key | The API Key for the application that the conversation belongs to |
| _links.self | A URL for the conversation resource |
| _embedded.legs.links | TODO |

#### Example: Retrieve details of a single conversation

```bash
$ curl https://api.nexmo.com/beta/conversations/{uuid} \
 -H 'Authorization: Bearer JWT' \
 -H 'Content-Type:application/json' \
 ```

##### Response

```json
{
  "uuid": "CON-e3aa61a7-000e-49e9-970a-9fc7d34a79e7",
  "name": "nexmo-chat",
  "display_name": "Nexmo Chat",
  "timestamp": {
    "created": "2017-07-19T19:35:33.108Z"
  },
  "sequence_number": 0,
  "numbers": {},
  "members": [],
  "api_key":"137aa1bf",
  "_links": {
    "self": {
      "href":"/conversations/CON-e3aa61a7-000e-49e9-970a-9fc7d34a79e7"
    }
  },
  "_embedded": {
    "legs": {
      "_links": []
    }
  }
}
```

<a name="conversations_post"></a>
### PUT
`https://api.nexmo.com/beta/conversations/{uuid}`

Modify an existing Conversation.

```
PUT /beta/conversations/{uuid}
Host: api.nexmo.com
Content-Type: application/json
Authorization: Bearer {JWT}

{JSON BODY}
```

The following table shows the parameters you use to modify a Conversation:

| Parameter | Description | Required |
| --- | --- | --- |
| | | |

**TODO:* Find out what properties can be modified. Are they propegated to the client?

#### Response

A successful response returns a `200` http status and contains the following keys and values:

| Key | Value |
| --- | --- |
| | |

**TODO:** document properties on response object

#### Example: Modify a conversation

```bash
TODO
```

##### Response

```json
TODO
```

<a name="users"></a>
## Users

You use the following requests to create, read, update and delete Users:

* [POST `https://api.nexmo.com/beta/users`](#users_post) - create a User
* [GET `https://api.nexmo.com/beta/users?`](#users_get_query) - query Users
* [GET `https://api.nexmo.com/beta/users/UUID`](#users_get_single) - get information about a single User
* [PUT `https://api.nexmo.com/beta/users`](#users_post) - modify an existing user
* [DELETE `https://api.nexmo.com/beta/users`](#users_delete) - delete a user

<a name="users_create"></a>
### POST
`https://api.nexmo.com/v1/users`

Create a User

```
POST /beta/users
Host: api.nexmo.com
Content-Type: application/json
Authorization: Bearer {JWT}

{JSON BODY}
```

The request should have a JSON body. The following table shows the parameters you use to create a User:

| Parameter | Description | Required |
| --- | --- |
| name | TODO | Y |
| display_name | TODO: confirm | Y |

#### Response

A successeful request will result in a `201` response with the following attributes.

| Key | Value |
| --- | --- |
| id | The unique identifier for the user |
| href | The URL for the resource |

**TODO:**

* `id` should be `uuid` to be consistent with VAPI
* `name` should be present as we have it for the resource
* `display_name` should be present as we have it for the resource
* `href` should be replaced with a HAL+JSON representation e.g.
  ```json
    "_links": {
      "self": {
        "href": "/conversations/63f61863-4a51-4f6b-86e1-46edebcf9356"
      }
    }
  ```

#### Example: Creating a User

```bash
$ curl -X POST https://api.nexmo.com/beta/users\
  -H 'Authorization: Bearer '$APP_JWT \
  -H 'Content-Type:application/json' \
  -d '{"name":"jamie"}'
```

##### Response

```json
{
  "id": "USR-9a88ad39-31e0-4881-b3ba-3b253e457603",
  "href": "http://conversation.local/v1/users/USR-9a88ad39-31e0-4881-b3ba-3b253e457603"
}
```
      

<a name="users_get_query"></a>

### GET
`https://api.nexmo.com/beta/users?{query}`

You use a GET request to query Users within your Nexmo application or retrieve all Users.

```
GET /beta/users?{query}
Host: api.nexmo.com
Content-Type: application/json
Authorization: Bearer {JWT}
```

The following table shows the parameters you use to query Users:

| Parameter | Description | Required |
| --- | --- | --- |
| | | |


#### Response

A successful request results in a `200` response  and contains the following keys and values:

| Key | Value |
| --- | --- |

TODO

#### Example: Retrieving all users

```bash
$ curl https://api.nexmo.com/beta/users \
 -H 'Authorization: Bearer JWT' \
 -H 'Content-Type:application/json' \
 ```

#### Example: Retrieving querying users

##### Response

```bash
TODO
 ```

<a name="users_get_single"></a>
### GET by UUID
`https://api.nexmo.com/beta/users/{uuid}`

Retrieve information about a single User.

```
GET /beta/users/{uuid}
Host: api.nexmo.com
Content-Type: application/json
Authorization: Bearer {JWT}
```

The following table shows the parameters you use when retrieving information about a User:

| Key | Value |
| --- | --- |
| uuid | The universally unique identifier for the user to be retrieved |

#### Response

A successful request returns a `200` response with the following keys and values:

| Key | Value |
| --- | --- |
| | |

#### Example: Retrieve details of a single user

```bash
$ curl https://api.nexmo.com/beta/users/{uuid} \
 -H 'Authorization: Bearer JWT' \
 -H 'Content-Type:application/json' \
 ```

##### Response

TODO

<a name="users_post"></a>
### PUT
`https://api.nexmo.com/beta/users/{uuid}`

Modify an existing User.

```
PUT /beta/users/{uuid}
Host: api.nexmo.com
Content-Type: application/json
Authorization: Bearer {JWT}

{JSON BODY}
```

The following table shows the parameters you use to modify a User:

| Parameter | Description | Required |
| --- | --- | --- |
| | | |

TODO

#### Response

A successful response returns a `200` http status and contains the following keys and values:

| Key | Value |
| --- | --- |
| | |

TODO

#### Example: Modify a user

```bash
TODO
```

##### Response

```json
TODO
```

<a name="members"></a>
## Members

You use the following requests to create, read, update and delete Members from Conversations:

* [POST `https://api.nexmo.com/beta/conversations/{uuid}/members`](#members_post)
* [GET `https://api.nexmo.com/beta/conversations/{uuid}/members`](#members_get)
* [PUT `https://api.nexmo.com/beta/conversations/{uuid}/members/{member_uuid}`](#members_put)
* [DELETE `https://api.nexmo.com/beta/conversations/{uuid}/members/{member_uuid}`](#members_delete)

<a name="conversations_post"></a>
### POST
`https://api.nexmo.com/beta/conversations/{conversation_uuid}/members/{member_uuid}`

Add a Member to a Conversation.

```
POST /beta/conversations/{conversation_uuid}/members/{member_uuid}
Host: api.nexmo.com
Content-Type: application/json
Authorization: Bearer {JWT}

{JSON BODY}
```

The following table shows the parameters you use to add a Member to a Conversation:

| Parameter | Description | Required |
| --- | --- | --- |
| | | |

TODO

#### Response

A successful response returns a `200` http status and contains the following keys and values:

| Key | Value |
| --- | --- |
| | |

TODO

#### Example: Add a member to a conversation

```bash
TODO
```

##### Response

```json
TODO
```

<a name="conversations_put"></a>
### PUT
`https://api.nexmo.com/beta/conversations/{conversation_uuid}/members/{member_uuid}`

Modify a Member within a Conversation.

```
PUT /beta/conversations/{conversation_uuid}/members/{member_uuid}
Host: api.nexmo.com
Content-Type: application/json
Authorization: Bearer {JWT}

{JSON BODY}
```

The following table shows the parameters you use to modify a Conversation:

| Parameter | Description | Required |
| --- | --- | --- |
| | | |

TODO

#### Response

A successful response returns a `200` http status and contains the following keys and values:

| Key | Value |
| --- | --- |
| | |

TODO

#### Example: Add a member to a conversation

```bash
TODO
```

##### Response

```json
TODO
```

<a name="conversations_post"></a>
### GET
`https://api.nexmo.com/beta/conversations/{conversation_uuid}/members`

Get the Members of a Conversation.

```
GET /beta/conversations/{conversation_uuid}/members/{member_uuid}
Host: api.nexmo.com
Content-Type: application/json
Authorization: Bearer {JWT}
```

The following table shows the parameters you use to retrieve members from a Conversation:

| Parameter | Description | Required |
| --- | --- | --- |
| | | |

TODO

#### Response

A successful response returns a `200` http status and contains the following keys and values:

| Key | Value |
| --- | --- |
| | |

TODO

#### Example: Retrieve members of a conversation

```bash
TODO
```

##### Response

```json
TODO
```

## Errors

Client errors return a payload with more details including Application level error

| HTTP Status Code | Description |
| 401 | Authentication |
| 404 | Not found (this includes a result that attempts to retrieve an object from a different application) |
| 429 | Too many requests (with retry after) |
| 400 | Other error (see payload for description) |

Error messages come with the following JSON body to provide more information:

```json
{ 
     code: <status_code>, 
 	   message: <string>
}
```
