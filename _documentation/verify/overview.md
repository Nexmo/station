---
title: Overview
description: the Verify API overview.
wip: true
---

# Verify API Overview

You use the Verify API to send a PIN by SMS or Text-To-Speech in order to prove that a user can be contacted at a specific phone number.

Verifying phone numbers is a mission-critical process you use for:

* SPAM Protection - prevent spammers from mass-creating messages
* Hack protection - if you detect suspicious or significant activities, validate that the person using a phone number owns it
* Reach Users - ensure you have the correct phone number to contact your user when you need to

By default, the PIN is first sent via SMS messaging. If there is no reply the Verify API makes a voice call using text-to-speech (TTS).

TTS messages are read in the locale that matches the phone number. (For example, the TTS for a 61* phone number is sent using an Australian accent for the English language (`en-au`). You can explicitly control the language, accent and gender in TTS from the Verify Request.)

Using the Verify API, the workflow to confirm that your user can be contacted at a specific phone number is:

![Verify API Overview image](https://docs.nexmo.com/assets/images/workflow_verify_api.svg)
