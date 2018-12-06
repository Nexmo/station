---
title: Verification stages
description: The stages of the verification process and default timings for each.
navigation_weight: 2
---

# Verification Stages

The following sequence diagram shows the order of events with the default timings if a user does not respond to the notifications they receive from the Verify API:

```js_sequence_diagram
Participant Your server
Participant Nexmo
Participant User's phone
Your server-> Nexmo: 1. You request verification \nof a number
Nexmo-->Your server: You receive the `request_id`
Note right of User's phone: SMS delivery is immediate
Nexmo->User's phone: 2. Nexmo sends \na verification code via SMS
Note right of User's phone: User is given 125 seconds \nto enter value recieved
Nexmo->User's phone: 3. Nexmo makes first \nTTS call to read \nthe code to the customer
Note right of User's phone: Wait for another 180 seconds
Note right of User's phone: If no code is entered, \nfirst code is expired
Nexmo->User's phone: 4. Nexmo makes second \nTTS call to read \na new code to the customer
Note right of User's phone: Wait for another 300 seconds
Nexmo-->Your server: If no code received from user,\nverification process expires
```

## Changing the default timings

You can change the default timings by supplying custom values for `pin_expiry` and/or `next_event_wait` in the initial request:

* `pin_expiry`:
    * The time after which the code expires
    * Must be an integer value between 60 and 3600 seconds
    * The default is 300 seconds
* `next_event_wait`:
    * The time after which Nexmo triggers the next verification attempt
    * Nexmo calculates the default value based on the average time users take to complete verification

If you specify values for both `pin_expiry` and `next_event_wait`, the value of `pin_expiry` must be an exact multiple of `next_event_wait`.

For example:

* `pin_expiry` = 360 seconds and `next_event_wait` = 120 seconds - all three attempts use the same verification code
* `pin_expiry` = 240 seconds and `next_event_wait` = 120 seconds - the first and second attempts use the same code and the Verify API generates a new code for the third attempt
* `pin_expiry` = 120 seconds (or 90 or 200 seconds) and `next_event_wait` = 120 seconds - the Verify API generates a new code for each attempt
