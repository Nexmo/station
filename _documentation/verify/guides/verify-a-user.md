---
title: Verify a user
wip: true

---

# Verify a user

## Send a verification request

Once you have collected a user's phone number, to start the verification process, you send an API request to Nexmo with the user's phone number.

<!-- API examples go here -->

The API will return an `request_id`.

## Check

Your application should now show a form to allow the user to enter the PIN they have received. Once you have received the PIN, you should send it back to Nexmo. The API will tell you whether it is correct.

<!-- API examples go here -->

## Cancel

If the user decides to cancel the verification process, you should send a cancellation request to Nexmo. This will prevent the verification process being completed even if the correct PIN is returned.

## Trigger next verification process

The Verify API starts the verification process by sending a text message to the user. If the PIN is not confirmed, Nexmo will attempt to contact the user via voice call.

You can make the API switch to the next verification process by sending an API call to the Verify Control endpoint. In the context of integrating the Verify API into your application, you should generally send this call to the API if the user has confirmed they would prefer to get a phone call.

<!-- API examples go here -->

