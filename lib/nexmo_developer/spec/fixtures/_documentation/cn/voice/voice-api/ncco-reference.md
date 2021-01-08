---
title:  NCCO 参考
description:  用于管理您的语音 API 呼叫的 Nexmo 呼叫控制对象。

---


NCCO 参考
=======

Nexmo 呼叫控制对象 (NCCO) 是一个 JSON 数组，可用于控制语音 API 呼叫的流程。为了使 NCCO 能够正确执行，JSON 对象必须有效。

在开发和测试 NCCO 时，您可以使用语音 Playground 交互式地试用 NCCO。您可以[在语音 API 概述中详细阅读相关信息](/voice/voice-api/overview#voice-playground)，或[直接转到 Dashboard 中的语音 Playground](https://dashboard.nexmo.com/voice/playground)。

NCCO 操作
-------

以 NCCO 中的操作顺序控制呼叫的流程。在执行下一个操作之前必须完成的操作即为 *同步* 。其他操作即为 *异步* 。也就是说，它们应该在满足条件之前继续执行以下操作。例如，当满足`endOnSilence`选项时，`record`操作即会终止。当 NCCO 中的所有操作均完成时，呼叫结束。

NCCO 操作以及每个操作的选项和类型为：

操作 | 说明 | 同步
-- | -- | --
[录音](#record) | 全部或部分通话 | 否
[对话](#conversation) | 创建或加入现有的[对话](/conversation/concepts/conversation) | 是
[连接](#connect) | 到可连接的端点，例如电话号码或 VBC 分机。| 是
[通话](#talk) | 将合成语音发送到对话。| 是，除非 *bargeIn=true*
[流式](#stream) | 将音频文件发送到对话。| 是，除非 *bargeIn=true*
[输入](#input) | 收集来自被呼叫者的数字。| 是
[通知](#notify) | 向您的应用程序发送请求，以便通过 NCCO 跟踪进度 | 是

> **注意** ：[连接呼入电话](/voice/voice-api/code-snippets/connect-an-inbound-call)提供了在启动呼叫或会议后如何为 Nexmo 提供 NCCO 服务的示例

录音
---

使用`record`操作对通话或部分通话进行录音：

```json
[
  {
    "action": "record",
    "eventUrl": ["https://example.com/recordings"]
  },
  {
    "action": "connect",
    "eventUrl": ["https://example.com/events"],
    "from":"447700900000",
    "endpoint": [
      {
        "type": "phone",
        "number": "447700900001"
      }
    ]
  }
]
```

录音操作为异步。当在 NCCO 中执行了录音动作时，录音即开始；当满足操作中的同步条件时，录音即结束。即，`endOnSilence`，`timeOut` 或 `endOnKey`。如果未设置同步条件，则语音 API 会立即执行下一个 NCCO，而不进行录音。

有关后续工作流程的信息，请参阅[录音](/voice/voice-api/guides/recording) 。

您可以使用以下选项来控制`record`操作：

选项 | 说明 | 必填
-- | -- | --
`format` | 以特定的格式对通话进行录音。选项如下：

* `mp3`
* `wav`
* `ogg`

录制超过两个信道时，默认值为 `mp3` 或 `wav`。| 否
`split` | 将发送和接收的音频分别录制在立体声录音的不同信道中—设置为`conversation`以启用此功能。|否
`channels` | 要录制的信道数量（最大值为 `32`）。如果参与者人数超过 `channels`，则任何其他参与者都将被添加到文件中的最后一个信道。同时必须启用拆分`conversation`。|否
`endOnSilence` | 静默 n 秒后停止录音。停止录音后，录音数据将发送到 `event_url`。可能的值范围是 3<=`endOnSilence`<=10。| 否
`endOnKey` | 按下手机上的数字即停止录音。可能的值为：`*`，`#` 或任何一位数字，例如 `9` | 否
`timeOut` | 录音最大长度（单位：秒）。录音停止后，录音数据将发送到 `event_url`。可能的值范围介于 `3` 秒和 `7200` 秒（2 小时） | 否
`beepStart` | 设置为 `true` 即可在录音开始时发出提示音 | 否
`eventUrl` | 录音完成时异步调用的 Webhook 端点的 URL。如果消息记录由 Nexmo 托管，则此 Webhook 包含[下载录音和其他元数据所需的 URL](#recording_return_parameters)。| 否
`eventMethod` | 用于向 `eventUrl` 发出请求的 HTTP 方法。默认值为 `POST`。| 否

<a id="recording_return_parameters"></a>
以下示例显示了发送到 `eventUrl` 的返回参数：

```json
{
  "start_time": "2020-01-01T12:00:00Z",
  "recording_url": "https://api.nexmo.com/v1/files/aaaaaaaa-bbbb-cccc-dddd-0123456789ab",
  "size": 12345,
  "recording_uuid": "aaaaaaaa-bbbb-cccc-dddd-0123456789ab",
  "end_time": "2020-01-01T12:01:00Z",
  "conversation_uuid": "bbbbbbbb-cccc-dddd-eeee-0123456789ab",
  "timestamp": "2020-01-01T14:00:00.000Z"
}
```

可能的返回参数为：

Name | Description
-- | --
`recording_uuid` | The unique ID for the Call.  
**Note** : `recording_uuid` is not the same as the file uuid in *recording\_url* .
`recording_url` | The  URL to the file containing the Call recording
`start_time`  | The time the recording started in ISO 8601 format: `YYYY-MM-DDTHH:MM:SSZ`. For example `2020-01-01T12:00:00Z`
`end_time`  | The time the recording finished in ISO 8601 format: `YYYY-MM-DDTHH:MM:SSZ`. For example `2020-01-01T12:00:00Z`
`size` | The size of the recording at *recording\_url* in bytes. For example: `603423`
`conversation_uuid` | The unique ID for this Call.

对话
---

您可以使用`conversation`操作来创建标准会议或仲裁会议，同时保留通信上下文。使用具有相同`name`的`conversation`会重复使用相同的持久式[对话](/conversation/concepts/conversation)。呼叫分配给对话的虚拟号码的第一人将进行创建。此操作为同步。

> **注意** ：您最多可以邀请 50 人加入您的对话。

以下 NCCO 示例展示了如何配置不同类型的连接。您可以使用 `answer_url` Webhook GET 请求参数来确保将一个 NCCO 传递给参与者，将另一个 NCCO 传递给仲裁人。

```tabbed_content
source: '/_examples/voice/guides/ncco-reference/conversation'
```

您可以使用以下选项来控制 *对话* 操作：

Option | Description | Required
-- | -- | --
`name` | The name of the Conversation room. Names are namespaced to the application level. | Yes
`musicOnHoldUrl` | A URL to the *mp3* file to stream to participants until the conversation starts. By default the conversation starts when the first person calls the virtual number associated with your Voice app. To stream this mp3 before the moderator joins the conversation, set *startOnEnter* to *false* for all users other than the moderator. | No
`startOnEnter` | The default value of *true* ensures that the conversation starts when this caller joins conversation `name`. Set to *false* for attendees in a moderated conversation. | No
`endOnExit` | Specifies whether a moderated conversation ends when the moderator hangs up. This is set to *false* by default, which means that the conversation only ends when the last remaining participant hangs up, regardless of whether the moderator is still on the call. Set `endOnExit` to *true* to terminate the conversation when the moderator hangs up. | No
`record` | Set to *true* to record this conversation. For standard conversations, recordings start when one or more attendees connects to the conversation. For moderated conversations, recordings start when the moderator joins. That is, when an NCCO is executed for the named conversation where *startOnEnter* is set to *true* . When the recording is terminated, the URL you download the recording from is sent to the event URL.  
By default audio is recorded in MP3 format. See the [recording](/voice/voice-api/guides/recording#file-formats) guide for more details | No
`canSpeak` | A list of leg UUIDs that this participant can be heard by. If not provided, the participant can be heard by everyone. If an empty list is provided, the participant will not be heard by anyone | No
`canHear` | A list of leg UUIDs that this participant can hear. If not provided, the participant can hear everyone. If an empty list is provided, the participant will not hear any other participants| No

连接
---

您可以使用`connect`操作将呼叫连接到端点，例如电话号码或 VBC 分机。

此操作为同步，在 *连接* 之后，将处理 NCCO 堆栈中的下一个操作。当您呼叫的端点繁忙或不可用时，连接操作就会结束。您可以通过嵌套连接操作来依次呼叫端点。

以下 NCCO 示例展示了如何配置不同类型的连接。

```tabbed_content
source: '/_examples/voice/guides/ncco-reference/connect'
```

您可以使用以下选项来控制`connect`操作：

选项 | 描述 | 必填
-- | -- | --
`endpoint` | 连接到单个端点。[可用端点类型](#endpoint-types-and-values) | 是
`from` | 用于标识呼叫者的 [E.164](https://en.wikipedia.org/wiki/E.164) 格式号码。§§这必须是您的 Nexmo 虚拟号码之一，另一个值将导致呼叫者 ID 未知。如果呼叫者是应用用户，则应忽略此选项。|否
`eventType` | 将`synchronous`设置为：

* 将`connect`操作设为同步
* 启用 `eventUrl` 以返回当呼叫移至特定状态时覆盖当前 NCCO 的 NCCO。

| 否
`timeout` |  如未应答呼叫，请设置 Nexmo 停止振铃`endpoint`之前的秒数。默认值为 `60`。
`limit` | 通话的最大长度（单位：秒）。默认和最大值为 `7200` 秒（2 小时）。| 否
`machineDetection` | 当 Nexmo 检测到目的地是电话答录机时配置行为。设置为以下任一种：

* `continue` - Nexmo 将带有呼叫事件的 HTTP 请求发送到 `event_url` `machine`
* `hangup` - 结束通话

| No `eventUrl` | Set the webhook endpoint that Nexmo calls asynchronously on each of the possible [Call States](/voice/voice-api/guides/call-flow#call-states). If `eventType` is set to `synchronous` the `eventUrl` can return an NCCO that overrides the current NCCO when a timeout occurs. | No `eventMethod` | The HTTP method Nexmo uses to make the request to *eventUrl* . The default value is `POST`. | No `ringbackTone` | A URL value that points to a `ringbackTone` to be played back on repeat to the **caller** , so they don't hear silence. The `ringbackTone` will automatically stop playing when the call is fully connected. It's not recommended to use this parameter when connecting to a phone endpoint, as the carrier will supply their own `ringbackTone`. Example: `"ringbackTone": "http://example.com/ringbackTone.wav"`. | No

### 端点类型和值

#### 电话 - E.164 格式的电话号码

Value | Description
-- | --
`number` | The phone number to connect to in [E.164](https://en.wikipedia.org/wiki/E.164) format.
`dtmfAnswer` | Set the digits that are sent to the user as soon as the Call is answered. The `*` and `#` digits are respected. You create pauses using `p`. Each pause is 500ms.
`onAnswer` | A JSON object containing a required `url` key. The URL serves an NCCO to execute in the number being connected to, before that call is joined to your existing conversation. Optionally, the `ringbackTone` key can be specified with a URL value that points to a `ringbackTone` to be played back on repeat to the **caller** , so they do not hear just silence. The `ringbackTone` will automatically stop playing when the call is fully connected. Example: `{"url":"https://example.com/answer", "ringbackTone":"http://example.com/ringbackTone.wav" }`. Please note, the key `ringback` is still supported.

#### 应用 - 将呼叫连接到应用

值 | 说明
-- | --
`user` | 要连接到的用户的用户名。此用户名必须已被[添加为用户](/api/conversation#createUser)

#### Websocket - 要连接到的 Websocket

值 | 说明
-- | --
`uri` | 您要流式传输到的 Websocket 的 URI。
`content-type` | 您正在流式传输音频的互联网媒体类型。可能的值为：`audio/l16;rate=16000` 或 `audio/l16;rate=8000`。
`headers` | 包含所需元数据的 JSON 对象。请参阅[连接到 Websocket](/voice/voice-api/guides/websockets#connecting-to-a-websocket) 以获取标头示例

#### SIP - 要连接到的 SIP 端点

值 | 说明
-- | --
`uri` | 您要连接到端点的 SIP URI，格式为 `sip:rebekka@sip.example.com`。
`headers` | `key` => `value` 包含任何所需元数据的字符串对，例如： `{ "location": "New York City", "occupation": "developer" }`

#### VBC - 要连接到的 Vonage Business Cloud (VBC) 分机

值 | 说明
-- | --
`extension` | 要将呼叫连接到的 VBC 分机。

通话
---

`talk`操作将合成语音发送到对话。

通话操作中提供的文本可以是纯文本，也可以是使用 [SSML](/voice/voice-api/guides/customizing-tts) 的格式化文本。SSML 标签为文本到语音合成器提供了进一步的说明，使您能够设置音调、发音，并将多种语言的文本组合在一起。SSML 标签基于 XML，并以 JSON 字符串内联发送。

默认情况下，通话操作为同步。但是，如果将 *bargeIn* 设置为 *true* ，则必须稍后在 NCCO 堆栈中设置 *输入* 操作。
以下 NCCO 示例展示了如何将合成语音消息发送到对话或呼叫：

```tabbed_content
source: '/_examples/voice/guides/ncco-reference/talk'
```

您可以使用以下选项来控制 *通话* 操作：

| Option | Description | Required |
| -- | -- | -- |
| `text` | A string of up to 1,500 characters (excluding SSML tags) containing the message to be synthesized in the Call or Conversation. A single comma in `text` adds a short pause to the synthesized speech. To add a longer pause a `break` tag needs to be used in SSML. To use [SSML](/voice/voice-api/guides/customizing-tts) tags, you must enclose the text in a `speak` element. | Yes |
| `bargeIn` | Set to `true` so this action is terminated when the user presses a button on the keypad. Use this feature to enable users to choose an option without having to listen to the whole message in your [Interactive Voice Response (IVR)](/voice/voice-api/guides/interactive-voice-response). If you set `bargeIn` to `true` the next non-talk action in the NCCO stack **must** be an `input` action. The default value is `false`.

Once `bargeIn` is set to `true` it will stay `true` (even if `bargeIn: false` is set in a following action) until an `input` action is encountered | No |
| `loop` | The number of times `text` is repeated before the Call is closed. The default value is 1\. Set to 0 to loop infinitely. | No |
| `level` | The volume level that the speech is played. This can be any value between `-1` to `1` with `0` being the default.  | No |
| `voiceName` | The name of the voice used to deliver `text`. You use the voiceName that has the correct language, gender and accent for the message you are sending. For example, the default voice `kimberly` is a female who speaks English with an American accent (en-US). Possible values are listed in the [Text-To-Speech guide](/voice/voice-api/guides/text-to-speech#voice-names). | No |

流式
---

`stream`操作可让您将音频流发送到对话

默认情况下，流式操作为同步。但是，如果将 *bargeIn* 设置为 *true* ，则必须稍后在 NCCO 堆栈中设置 *输入* 操作。

以下 NCCO 示例展示了如何将音频流发送到对话或呼叫：

```tabbed_content
source: '/_examples/voice/guides/ncco-reference/stream'
```

您可以使用以下选项来控制 *流式* 操作：

Option | Description | Required
-- | -- | --
`streamUrl` | An array containing a single URL to an mp3 or wav (16-bit) audio file to stream to the Call or Conversation. | Yes
`level` |  Set the audio level of the stream in the range -1 >=level<=1 with a precision of 0\.1\. The default value is *0* . | No
`bargeIn` | Set to *true* so this action is terminated when the user presses a button on the keypad. Use this feature to enable users to choose an option without having to listen to the whole message in your [Interactive Voice Response (IVR](/voice/guides/interactive-voice-response) ). If you set `bargeIn` to `true` on one more Stream actions then the next non-stream action in the NCCO stack **must** be an `input` action. The default value is `false`.

Once `bargeIn` is set to `true` it will stay `true` (even if `bargeIn: false` is set in a following action) until an `input` action is encountered | No
`loop` | The number of times `audio` is repeated before the Call is closed. The default value is `1`. Set to `0` to loop infinitely. | No

The audio stream referred to should be a file in MP3 or WAV format. If you have issues with the file playing, please encode it to the following technical specification: [What kind of prerecorded audio files can I use?](https://help.nexmo.com/hc/en-us/articles/115007447567)

输入
---

您可以使用`input`操作来收集被呼叫者输入的数字。此操作为同步，Nexmo 处理输入并将其以发送到您在请求中配置的 `eventUrl` Webhook 端点的[参数](#input-return-parameters)转发。您的 Webhook 端点应返回另一个 NCCO 以替换现有的 NCCO，并根据用户输入控制呼叫。您可以使用此功能来创建交互式语音应答 (IVR)。例如，如果您的用户按 *4* ，则返回一个 [连接](#connect) NCCO，将呼叫转发给您的销售部门。

以下 NCCO 示例展示了如何配置 IVR 端点：

```json
[
  {
    "action": "talk",
    "text": "Please enter a digit"
  },
  {
    "action": "input",
    "eventUrl": ["https://example.com/ivr"]
  }
]
```

以下 NCCO 示例展示了如何使用 `bargeIn` 来允许用户中断`talk`操作。请注意，`input`操作 **必须** 在具有 `bargeIn` 属性的任何操作之后进行（例如，`talk`或`stream`）。

```json
[
  {
    "action": "talk",
    "text": "Please enter a digit",
    "bargeIn": true
  },
  {
    "action": "input",
    "eventUrl": ["https://example.com/ivr"]
  }
]
```

以下选项可用于控制`input`操作：

选项 | 说明 | 必填
-- | -- | --
`timeOut` | 被叫方活动的结果在上一个操作之后的 `timeOut` 秒发送到 `eventUrl` Webhook 端点。默认值为 *3* .最大值为 10。| 否
`maxDigits` | 用户可以按下的位数。最大值为 `20`，默认值为 `4` 位数。| 否
`submitOnHash` | 设置为 `true`，以便在被叫方按 *\#* 后将其活动发送到位于 `eventUrl` 的 Webhook 端点。如果未按 *＃* ，则结果将在 `timeOut` 秒后提交。默认值为 `false`。也就是说，结果在 `timeOut` 秒后发送到您的 Webhook 端点。| 否
`eventUrl` | 在`timeOut`暂停处于活动状态，或按 *\#* 后，Nexmo 会将被叫方按下的数字发送到此 URL。| 否
`eventMethod` | 用于将事件信息发送到 `event_url` 的 HTTP 方法。默认值为 POST。|否

以下示例显示了发送到 `eventUrl` 的参数：

```json
{
  "uuid": "aaaaaaaa-bbbb-cccc-dddd-0123456789ab",
  "conversation_uuid": "bbbbbbbb-cccc-dddd-eeee-0123456789ab",
  "timed_out": true,
  "dtmf": "1234",
  "timestamp": "2020-01-01T14:00:00.000Z"
}
```

#### 输入返回参数

返回到 `eventUrl` 的输入参数为：

名称 | 说明
-- | --
`uuid` | 用户发起输入的呼叫链路的唯一 ID。
`conversation_uuid` | 此对话的唯一 ID。
`timed_out` | 如果此输入基于`timeOut`的值超时，则返回 `true`。
`dtmf` | 被叫方按顺序输入的号码。

通知
---

Use the `notify` action to send a custom payload to your event URL. Your webhook endpoint can return another NCCO that replaces the existing NCCO or return an empty payload meaning the existing NCCO will continue to execute.

```json
[
  {
    "action": "notify",
    "payload": {
      "foo": "bar"
    },
    "eventUrl": [
      "https://example.com/webhooks/event"
    ],
    "eventMethod": "POST"
  }
]
```

选项 | 说明 | 必填
-- | -- | --
`payload` | 发送到您的事件 URL 的 JSON 正文 | 是
`eventUrl` | 要将事件发送到的 URL。如果在收到通知时返回一个 NCCO，它将替换当前的 NCCO | 是
`eventMethod` | 向您的 `eventUrl` 发送`payload`时使用的 HTTP方法 | 否

