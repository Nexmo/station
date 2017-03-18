package com.nexmo.quickstart.voice;

import com.nexmo.client.NexmoClient;
import com.nexmo.client.auth.AuthMethod;
import com.nexmo.client.auth.JWTAuthMethod;
import com.nexmo.client.voice.Call;
import com.nexmo.client.voice.CallEvent;

import java.nio.file.FileSystems;

import static com.nexmo.quickstart.Util.configureLogging;
import static com.nexmo.quickstart.Util.envVar;

public class SendTalkToCall {
    public static void main(String[] args) throws Exception {
        configureLogging();

        String APPLICATION_ID = envVar("APPLICATION_ID");
        String PRIVATE_KEY = envVar("PRIVATE_KEY");
        String FROM_NUMBER = envVar("FROM_NUMBER");
        String TO_NUMBER = envVar("TO_NUMBER");

        AuthMethod auth = new JWTAuthMethod(
                APPLICATION_ID,
                FileSystems.getDefault().getPath(PRIVATE_KEY)
        );
        NexmoClient client = new NexmoClient(auth);
        CallEvent call = client.getVoiceClient().createCall(new Call(
                TO_NUMBER,
                FROM_NUMBER,
                "https://gist.githubusercontent.com/ChrisGuzman/d6add5b23a8cf913dcdc5a8eabc223ef/raw/a1eb52e0ce2d3cef98bab14d27f3adcdff2af881/long_talk.json"
        ));

        Thread.sleep(20000);

        client.getVoiceClient().startTalk(call.getUuid(), "Hello World! Would you like to know more? I bet you would", 0);
        Thread.sleep(5000);
        client.getVoiceClient().stopTalk(call.getUuid());
    }
}
