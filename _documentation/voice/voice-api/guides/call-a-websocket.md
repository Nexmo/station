---
title: Call a WebSocket
---

# Call a WebSocket

Using Nexmo’s Voice API, you can connect PSTN phone calls to WebSocket endpoints. This means that any app that hosts a WebSocket server can now be a participant in a Nexmo voice conversation. Voice API removes all the hard work, a WebSocket is just another endpoint that you can connect to using an NCCO or an API call.

WebSockets is a computer communications protocol that provides full-duplex communication channels over a single TCP connection. WebSocket is implemented in Web browsers and web servers. For example, the Firefox and Google Chrome browsers, and the Tornado Web server.

Easy WebSocket connections using Voice API enables some innovative use cases, including easily integrating:

* Artificial intelligence engines and bots (like Amazon's Lex platform) that can be conferenced into a meeting to enable faster decision making.
* Analysis engines into voice calls to determine sentiment.
* Bots that:
  * Make outbound calls to do simple tasks such as making a restaurant reservation or more complex ones, such as requesting information from field experts.
  * Take inbound calls and make their expertise more readily available. For example, a doctor in a small village in Tanzania can call a medical expert bot and get access to the same medical advice available to specialists at the Mayo Clinic.
* Third party voice recognition, recording, and transcription engines.

In this section you see how to easily test a Voice API *connect* to a WebSocket endpoint. You create a NCCO that connects an inbound PSTN call to the echo server using WebSocket and a dual function server that provisions NCCOs and echoes voice messages back to a Websocket:

* [Prerequisites](#prerequisites) - what you need to follow the instructions in this section
* [Create your echo server](#create_echo) - create an echo server for WebSocket
* [Connect a PSTN call to a WebSocket](#create_app) - use Voice API to easily connect to the echo server using a WebSocket

## Prerequisites

To follow the steps in this section you need a:

* [Nexmo account](/account/guides/management#create-and-configure-a-nexmo-account)
* [Nexmo application](/concepts/guides/applications#apps_quickstart)
* If you are working locally, an HTTP tunneling software such as https://ngrok.com/

## Create an echo server

The echo server provides the NCCO used by Nexmo to connect to a WebSocket and the WebSocket Voice API connects to.

When Voice API connects to a WebSocket endpoint, Nexmo makes an initial HTTP GET request for a WebSocket. The server responds with an HTTP 101 to switch protocols, the connection is upgraded to WebSocket. At that point you have a persistent TCP connection between Nexmo and the echo server. The initial message sent by Nexmo is plain text with metadata. Other text messages are sent mid-stream. You should inspect each message to determine if it contains text or binary data and parse binary frames only as audio.

When a message is received, the echo server tests if it binary. If so, it is echoed to the originator. Once the connection is established, fully bidirectional messages can originate from either end and do not need a response. Text messages are printed to the console. When the client terminates the connection it is removed from the list.

In a real world implementation, you either record the binary message to a file or pass the data to some audio processing code. You can also send audio back to the call at any point. You do not have to respond to an incoming message.

To create and run your echo server:

1. Depending on the language you use, copy the following code to a local file `echo_server`:

    ```tabbed_content
    source: '_examples/voice/guides/call-a-websocket/echo-server'
    ```

2. If you are running the server locally, open an http tunnel to the echo server:

    ```
    ngrok http 8000
    ```

3. Note the URL to your echo server.

##Connect a PSTN voice call to a WebSocket

To the Voice API, a WebSocket is just another endpoint. When you call the virtual number associated with your application, the NCCO at *answer_url* tells Voice API to connect your inbound call to the echo server using a WebSocket. If you use the NCCO below, you'll hear a brief introductory message before being connected to the WebSocket.

```js_sequence_diagram
Participant App answer_url
Participant Nexmo
Participant User
Participant EchoServer
User->Nexmo: Call virtual number
Nexmo->App answer_url: Send Call info
App answer_url->Nexmo: Return NCCO with\nWebSocket connect
Nexmo->EchoServer: Initiate Call leg
User->EchoServer: Hi.
EchoServer->User: Hi.
```

To connect an inbound PSTN call to the echo server using a WebSocket:

1. Use the following template to create `ncco.json`. This file contains the NCCO to connect an incoming PSTN call to a WebSocket:

    ```json
    [
      {
        "action":"talk",
        "text":"Please wait while we connect you"
      },
      {
        "action":"connect",
        "eventUrl":[
          "https://example.com/events"
        ],
        "from":"447700900000",
        "endpoint":[
          {
            "type":"websocket",
            "uri":"ws://example.com/socket",
            "content-type":"audio/l16;rate=16000",
            "headers":{
              "whatever":"metadata_you_want"
            }
          }
        ]
      }
    ]
    ```

2. Place `ncco.json` in the same directory as `echo_server.py`.

3. Ensure that answer_url for your Application is pointing to the echo server. If not, use the [Nexmo CLI](/tools) or [Application API](/api/application#update) to update `answer_url`.

4. Call the virtual number associated with your Application and listen to your own words of wisdom.

And that is it. Using Voice API you have connected a PSTN call to a WebSocket.
