Method | Endpoint
-- | --
[GET] | `https://api.nexmo.com/v1/calls/{call_uuid}`
[PUT] | `https://api.nexmo.com/v1/calls/{call_uuid}`
[PUT] | `https://api.nexmo.com/v1/calls/{uuid}/stream`
[DELETE] | `https://api.nexmo.com/v1/calls/{uuid}/stream`
[PUT] | `https://api.nexmo.com/v1/calls/{uuid}/talk`
[DELETE] | `https://api.nexmo.com/v1/calls/{uuid}/talk`
[PUT] | `https://api.nexmo.com/v1/calls/{call_uuid}/dtmf`

After a Call is terminated you retrieve the Call uuid with a request to GET `https://api.nexmo.com/v1/calls`.
