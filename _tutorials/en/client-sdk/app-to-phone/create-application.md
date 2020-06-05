---
title: Create a Nexmo Application
description: In this step you learn how to create a Nexmo Application.
---

# Create your Nexmo Application

You now need to create a Nexmo application. In this step you create an application capable of handling both in-app Voice and in-app Messaging use cases.

1) First create your project directory if you've not already done so.

2) Change into the project directory.

3) Create a Nexmo application by copying and pasting the command below. Make sure to replace `GITHUB-GIST-RAW-URL` (the URL from the previous step) and `App Name` with a name for your application.

``` shell
nexmo app:create --capabilities=voice --keyfile=private.key  --voice-event-url=https://example.com/ --voice-answer-url=GITHUB-GIST-RAW-URL "App Name"
```

> **NOTE:** An application can be also created using the CLI's [interactive mode](/application/nexmo-cli#interactive-mode).

The application is then created.

The file `.nexmo-app` is created in your project directory. This file contains the Nexmo Application ID and the private key. A private key file `private.key` is also created.

Creating an application and application capabilities are covered in detail in the [documentation](/application/overview).

Make a note of the generated Application ID, as you'll need it in the future. 

## Nexmo Dashboard

You can obtain information about your application, including Application ID, in the [Nexmo Dashboard](https://dashboard.nexmo.com/voice/your-applications).

![Nexmo Developer Dashboard Applications screenshot](/assets/screenshots/tutorials/app-to-phone/nexmo-dashboard-applications.png "Nexmo Developer Dashboard Applications screenshot")
