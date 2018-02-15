## Inviting Members with the Nexmo Conversation Android SDK

In this getting started guide we'll demonstrate creating a second user and inviting them to the Conversation we created in the [simple conversation](1-simple-conversation.md) getting started guide. From there we'll list the conversations that are available to the user and upon receiving an invite to new conversations we'll automatically join them.

## Concepts

This guide will introduce you to the following concepts:

* **Invites** - How to invite users to a conversation
* **Application Events** - Attaching the `ConversationInvitedListener` to a `ConversationClient`, before you are a Member of a Conversation
* **Conversation Events** - Attaching the `MemberJoinedListener` and `MessageListener` listeners to a Conversation, after you are a Member


### Before you begin


* Ensure you have run through the [previous guide](1-simple-conversation.md)
* Make sure you have two Android devices to complete this example. They can be two emulators, one emulator and one physical device, or two physical devices.

## 1 - Setup

_Note: The steps within this section can all be done dynamically via server-side logic. But in order to get the client-side functionality we're going to manually run through the setup._

### 1.1 - Create another User

If you're continuing on from the previous guide you may already have a `APP_JWT`. If not, generate a JWT using your Application ID (`YOUR_APP_ID`).

```bash
$ APP_JWT="$(nexmo jwt:generate ./private.key application_id=YOUR_APP_ID exp=$(($(date +%s)+86400)))"
```

Create another user who will participate within the conversation.

```bash
$ curl -X POST https://api.nexmo.com/beta/users\
  -H 'Authorization: Bearer '$APP_JWT \
  -H 'Content-Type:application/json' \
  -d '{"name":"alice"}'
```

The output will look as follows:

```json
{"id":"USR-9a88ad39-31e0-4881-b3ba-3b253e457603","href":"http://conversation.local/v1/users/USR-9a88ad39-31e0-4881-b3ba-3b253e457603"}
```

Take a note of the `id` attribute as this is the unique identifier for the user that has been created. We'll refer to this as `USER_ID` later.

### 1.2 - Generate a User JWT

Generate a JWT for the user. The JWT will be stored to the `SECOND_USER_JWT` variable. Remember to change the `YOUR_APP_ID` value in the command.

```bash
$ SECOND_USER_JWT="$(nexmo jwt:generate ./private.key sub=alice exp=$(($(date +%s)+86400)) acl='{"paths": {"/v1/sessions/**": {}, "/v1/users/**": {}, "/v1/conversations/**": {}}}' application_id=YOUR_APP_ID)"
```

*Note: The above command sets the expiry of the JWT to one day from now.*

You can see the JWT for the user by running the following:

```bash
$ echo $SECOND_USER_JWT
```

## 2 Update the Android App

We will use the application we already created for [the first getting started guide](1-simple-conversation.md). With the basic setup in place we can now focus on updating the client-side application.

### 2.1 Update the stubbed out Login

Now, let's update the login workflow to accommodate a second user.

Define a variable with a value of the second User JWT that was created earlier and set the value to the `SECOND_USER_JWT` that was generated earlier.

```java
//LoginActivity.java
public class LoginActivity extends AppCompatActivity {
    private static final String TAG = LoginActivity.class.getSimpleName();
    private String USER_JWT = YOUR_USER_JWT;
    private String SECOND_USER_JWT = YOUR_SECOND_USER_JWT;
    ...
}
```

Update the authenticate function. We'll return the USER_JWT value if the username is 'jamie' or SECOND_USER_JWT for any other username.


```java
//LoginActivity.java
private String authenticate(String username) {
        return username.toLowerCase().equals("jamie") ? USER_JWT : SECOND_USER_JWT;
    }

    private void login() {
        final EditText input = new EditText(LoginActivity.this);
        final AlertDialog.Builder dialog = new AlertDialog.Builder(LoginActivity.this)
                .setTitle("Enter the username you are logging in as")
                .setPositiveButton("Login", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        String userToken = authenticate(input.getText().toString());
                        loginAsUser(userToken);
                    }
                });

        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.MATCH_PARENT);
        input.setLayoutParams(lp);
        dialog.setView(input);

        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                dialog.show();
            }
        });
    }

private void loginAsUser(String token) {
    conversationClient.login(token, new RequestHandler<User>() {
        @Override
        public void onSuccess(User user) {
            showLoginSuccessAndAddInvitationListener(user);
            retrieveConversations();
        }

        @Override
        public void onError(NexmoAPIError apiError) {
            logAndShow("Login Error: " + apiError.getMessage());
        }
    });
}

```

We'll be running this device on two different devices (on an emulator or physical devices), so we'll first ask which user you're logging in as. When you enter a username we'll login with their JWT. We'll also add an invitation listener and retrieve any conversations that user is already a part of. Let's cover what the `showLoginSuccessAndAddInvitationListener(user)` method will do.

### 2.2 Listening for Conversation invites and accepting them

The next step is to update the login method to listen on the application with the ConversationInvitedListener. Once we receive an invite, we're going to automatically join the user to that Conversation.

```java
//LoginActivity.java
private void showLoginSuccessAndAddInvitationListener(final User user) {
    conversationClient.invitedEvent().add(new ResultListener<Invitation>() {
        @Override
        public void onSuccess(Invitation result) {
            logAndShow(result.getInvitedBy() + " invited you to their chat");
            result.getConversation().join(new RequestHandler<Member>() {
                @Override
                public void onSuccess(Member result) {
                    goToConversation(result.getConversation());
                }

                @Override
                public void onError(NexmoAPIError apiError) {
                    logAndShow("Error joining conversation: " + apiError.getMessage());
                }
            });
        }
    });
    runOnUiThread(new Runnable() {
        @Override
        public void run() {
            loginTxt.setText("Logged in as " + user.getName() + "\nStart chatting!");
        }
    });
}
```

To respond to events where a user is invited to a conversation, you can add a `ResultListener<Invitation>` to a `invitedEvent()` on an instance of `ConversationClient`. In this example we're going to show that the user was invited, join the conversation, and then navigate to our `ChatActivity` to participate in that conversation. The `ResultListener<Invitation>` only has a success callback: `onSuccess`, which means the user successfully received the invite.

Now let's go back to our `retrieveConversations()` method:

### 2.3 List the Conversations and handle selecting one

```java
//LoginActivity.java
private void retrieveConversations() {
    conversationClient.getConversations(new RequestHandler<List<Conversation>>() {
        @Override
        public void onSuccess(List<Conversation> conversationList) {
            if (conversationList.size() > 0) {
                showConversationList(conversationList);
            } else {
                logAndShow("You are not a member of any conversations");
            }
        }

        @Override
        public void onError(NexmoAPIError apiError) {
            logAndShow("Error listing conversations: " + apiError.getMessage());
        }
    });
}
```

There are two ways to see what conversations a member is a part of. `conversationClient.getConversations()` retrieves the full list of conversations the logged in user is a Member of asynchronously. If you want retrieve the list of conversations a user is a part of in a synchronous manner, you can call `conversationClient.getConversationList()`

If there wasn't an error retrieving the list of conversations, we'll check if the user has more than one conversation that they are a part of. If there is more than one conversation, then we'll show a dialog allowing the user to select a conversation to enter. If the user doesn't have any conversations then we'll show a message telling them so.

For now, let's show the list of conversations.

```java
//LoginActivity.java
private void showConversationList(final List<Conversation> conversationList) {
    List<String> conversationNames = new ArrayList<>(conversationList.size());
    for (Conversation convo : conversationList) {
        conversationNames.add(convo.getDisplayName());
    }

    final AlertDialog.Builder dialog = new AlertDialog.Builder(LoginActivity.this)
            .setTitle("Choose a conversation")
            .setItems(conversationNames.toArray(new CharSequence[conversationNames.size()]), new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialog, int which) {
                    goToConversation(conversationList.get(which));
                }
            });

    runOnUiThread(new Runnable() {
        @Override
        public void run() {
            dialog.show();
        }
    });
}
```

We'll loop through the conversations the user is a member of and then show that list in a AlertDialog. When the user selects on of the already created conversations, we'll go to the `ChatActivity` with that conversation, passing along the conversation ID in an extra like in our first quickstart.

### 2.4 - Run the apps

Run the apps on both of your emulators. On one of them, login with the username "jamie". On the other emulator login with the username "alice"

### 2.5 - Invite the second user to the conversations

Finally, let's invite the user to the conversation that we created.

In your terminal, run the following command and remember to replace `YOUR_CONVERSATION_ID` in the URL with the ID of the Conversation you created in the first guide and the `SECOND_USER_ID` with the one you got when creating the User for `alice`.

```bash
$ curl -X POST https://api.nexmo.com/beta/conversations/YOUR_CONVERSATION_ID/members\
 -H 'Authorization: Bearer '$APP_JWT -H 'Content-Type:application/json' -d '{"action":"invite", "user_id":"SECOND_USER_ID", "channel":{"type":"app"}}'
```

The response to this request will confirm that the user has been `INVITED` the "Nexmo Chat" conversation.

```json
{"id":"MEM-fe168bd2-de89-4056-ae9c-ca3d19f9184d","user_id":"USR-f4a27041-744d-46e0-a75d-186ad6cfcfae","state":"INVITED","timestamp":{"invited":"2017-06-17T22:23:41.072Z"},"channel":{"type":"app"},"href":"http://conversation.local/v1/conversations/CON-8cda4c2d-9a7d-42ff-b695-ec4124dfcc38/members/MEM-fe168bd2-de89-4056-ae9c-ca3d19f9184d"}
```

You can also check that `alice` was invited by running the following request, replacing `YOUR_CONVERSATION_ID`:

```bash
$ curl https://api.nexmo.com/beta/conversations/YOUR_CONVERSATION_ID/members\
 -H 'Authorization: Bearer '$APP_JWT
```

Where you should see a response similar to the following:

```json
[{"user_id":"USR-f4a27041-744d-46e0-a75d-186ad6cfcfae","name":"MEM-fe168bd2-de89-4056-ae9c-ca3d19f9184d","user_name":"alice","state":"INVITED"}]
```

Return to your emulators so you can see `alice` has a conversation listed now. You can click the conversation name and proceed to chat between `alice` and `jamie`.

# Trying it out

Once you've completed this quickstart, you can run the sample app on two different devices. You'll be able to login as a user, join an existing conversation or receive invites, and chat with users. Here's a gif of our quickstart in action.

![Awesome Chat](http://g.recordit.co/Us6wTTvKnI.gif)
