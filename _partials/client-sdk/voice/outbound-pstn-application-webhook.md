For your application to connect an app user to a phone call, you'll need to provide a URL as the `Answer URL` webhook - we've created a [gist](https://gist.github.com/NexmoDev/f11d10f21fe426ddac4e30b94c6b28dc) for you to fork and update with your Nexmo phone number and personal phone number.

After you've forked and saved the gist to your account, press the "Raw" button to get a link to the raw json file. We'll need to set this as the answer URL for your Nexmo application.

To add this URL, go to your [Nexmo dashboard](https://dashboard.nexmo.com), navigate to [applications](https://dashboard.nexmo.com/voice/your-applications), select your application and click the 'Edit' button.

Now, set the application's `Answer URL` to your raw gist URL. It should look something like this:

``https://gist.githubusercontent.com/NexmoDev/f11d10f21fe426ddac4e30b94c6b28dc/raw/b14c4087097ab67503b4fdd996269502e107bce6/call-phone.json``

and click 'Save changes'.

> NOTE: This gist is specific to this tutorial and in a real-life scenario, the `answer_url` should be provided by a purposely built web solution that can serve custom NCCOs if required.
