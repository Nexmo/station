
Create group chats with any number of members to communicate real time.


## Integrating with Audio Calling APIs
After the [SDK integration](https://github.com/nexmoinc/conversation-android-sdk/blob/develop/README.md), follow below steps to enable audio call.

Prequisites: add audio related permissions to your Manifest file to enable audio support:

```java
    <!-- Audio support dependencies. Developer of the app to ask for these permissions. -->
    <uses-permission android:name="android.permission.MODIFY_AUDIO_SETTINGS" />
    <uses-permission android:name="android.permission.RECORD_AUDIO" />
```

### Initiate a call
This is a helper method that automatically creates a conversation and enables audio for current user, 
while waiting for the invited users to join.

```java
    List<String> users = Arrays.asList("userA", "userB");
    conversationClient.call(users, new RequestHandler<Call>() {
        @Override
        public void onError(NexmoAPIError apiError) {
            Log.d(TAG, "Cannot initiate call: " + apiError.toString());
        }

        @Override
        public void onSuccess(Call result) {
            // Call created, users have been invited to join.
            Log.d(TAG, "Waiting for users to join call: " + result.getName());
        }
    });
```

### Listen for incoming calls
Register for receiving incoming call events.

```java
        RequestHandler<Call> incomingCallListener = new RequestHandler<Call>() {
            @Override
            public void onError(NexmoAPIError apiError) {
                Log.d(TAG, apiError.toString());
                displayToast("Incoming CALL error: " + apiError.toString());
            }

            @Override
            public void onSuccess(final Call incomingCall) {
                Log.d(TAG, "Incoming call: " + incomingCall.toString());
            }
        };
        client.callEvent().add(incomingCallListener);
```

### Answer an incoming call

```java
        RequestHandler<Call> incomingCallListener = new RequestHandler<Call>() {
            @Override
            public void onError(NexmoAPIError apiError) {
                Log.d(TAG, apiError.toString());
                displayToast("Incoming CALL error: " + apiError.toString());
            }

            @Override
            public void onSuccess(final Call incomingCall) {
                Log.d(TAG, "Incoming call: " + incomingCall.toString());
                incomingCall.answer(new RequestHandler<Void>() {
                    @Override
                    public void onError(NexmoAPIError apiError) {
                    }

                    @Override
                    public void onSuccess(Void result) {
                        showCallActivity(incomingCall.getConversation());
                    }
                });
            };
        client.callEvent().add(incomingCallListener);
```

### Hangup during a call

```java
    call.hangup(new RequestHandler<Void>() {
        @Override
        public void onError(NexmoAPIError apiError) {
            Log.d(TAG, "Cannot hangup: " + apiError.toString());
        }

        @Override
        public void onSuccess(Void result) {
            Log.d(TAG, "Call completed.");
        }
    });
```

### Enable audio in an existing conversation
Enable Audio calls in the current conversation.
Only one audio conversation is supported at a time, so trying to enable audio simultaneously will fail with *NexmoAPIError#audioAlreadyInProgress()*

```java
    conversation.audio().enable(new AudioCallEventListener() {
        @Override
        public void onRinging() {
        // audio connection is in progress
        }

        @Override
        public void onCallConnected() {
            // audio connection has been established. audio stream is flowing between members.

        }

        @Override
        public void onCallEnded() {
            // audio call has been ended.
        }

        @Override
        public void onGeneralCallError(NexmoAPIError apiError) {
            // any audio related error.
        }

        @Override
        public void onAudioRouteChange(AppRTCAudioManager.AudioDevice device) {

        }
    });
```

### Disable audio in an existing conversation
Disable current audio call in the conversation.

```java
     conversation.audio().disable(new RequestHandler() {
        @Override
        public void onError(NexmoAPIError apiError) {
        }

        @Override
        public void onSuccess(Void result) {

        }
    });
```

## Invitations

### Already existing conversation, invite other user with audio enabled
Invite a user to an audio conversation, using preset params for muted and earmuff.
A user accepting an invite to a conversation with audio enabled will need to manually enable audio after accepting invitation.

```java
    conversation.inviteWithAudio("USER-ID", "USERNAME", muted, earmuffed, new RequestHandler<Member>() {
        @Override
        public void onError(NexmoAPIError apiError) {
        }

        @Override
        public void onSuccess(Member result) {

        }
    });
```

### Receive audio invitations to new conversations
Register for receiving invitation events from new conversations.
Check if invitation has audio enabled *invitation.isAudioEnabled* in order to display different incoming call UI.

```java
    client.invitedEvent().add(new ResultListener<Invitation>() {
        @Override
        public void onSuccess(final Invitation invitation) {
            if (invitation.isAudioEnabled())
                invitation.getConversation().join(new RequestHandler<Member>() {
                    @Override
                    public void onError(NexmoAPIError apiError) {

                   }

                   @Override
                   public void onSuccess(Member result) {
                        // joined, ready to enable audio.
                    }
                });
            }
        });
    });
```

## Audio controlls

### Mute/unmute self
Mute self in the current audio call.

```java
        conversation.audio().mute(isChecked, new RequestHandler<Void>() {
            @Override
            public void onError(NexmoAPIError apiError) {

            }

            @Override
            public void onSuccess(Void result) {

            }
        });
```