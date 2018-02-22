curl -X "POST" "https://api.nexmo.com/beta/workflows" \
  -H "Authorization: Bearer "$JWT\
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json' \
  -d $'[
    {
      "from": { "type": "viber_service_msg", "id": "VIBER_SERVICE_MESSAGE_ID" }
      "to": { "type": "viber_service_msg", "number": "TO_NUMBER" },
      "message": {
        "content": {
          "type": "text",
          "text": "This is a Viber Service Message sent from the Messages API"
        }
      },
      "failover": {
        "condition_status": "delivered",
        "expiry_time": 600
      },
    },
    {
      "to": { "type": "sms", "number": "TO_NUMBER" },
      "from": { "type": "sms", "number": "FROM_NUMBER" }
      "message": {
        "content": {
          "type": "text",
          "text": "This is an SMS sent from the Messages API"
        }
      },
    }
  ]'
