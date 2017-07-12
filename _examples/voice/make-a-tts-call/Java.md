---
title: Java
language: java
---

Create your `build.gradle file` and list your dependencies:

```gradle
// build.gradle

repositories {
    mavenCentral()
}

dependencies {
    compile 'com.nexmo:client:2.0.2'
}

task fatJar(type: Jar, dependsOn:configurations.runtime) {
    baseName = project.name + '-with-dependencies'
    from { configurations.runtime.collect { it.isDirectory() ? it : zipTree(it) } }
    with jar
}
assemble.dependsOn fatJar
```

Create a Java source file that uses the client library to make a call. Replace `APPLICATION_ID`, `PRIVATE_KEY_PATH`, `TO_NUMBER`, and `FROM_NUMBER` with your values.

```java
// src/main/java/mypackage/MakeCall.class
package mypackage;

import com.nexmo.client.NexmoClient;
import com.nexmo.client.auth.JWTAuthMethod;
import com.nexmo.client.voice.Call;

import java.nio.file.FileSystems;

public class MakeCall {
    public static void main(String[] args) throws Exception {
        NexmoClient client = new NexmoClient(new JWTAuthMethod(
                "APPLICATION_ID",
                FileSystems.getDefault().getPath("PRIVATE_KEY_PATH")
        ));
        client.getVoiceClient().createCall(new Call(
                "TO_NUMBER",
                "FROM_NUMBER",
                "https://nexmo-community.github.io/ncco-examples/first_call_talk.json"
        ));
    }
}
```

Build a JAR file containing the class and the nexmo client library:

```bash
gradle build
```

Run the application:

```bash
java -cp "build/libs/PROJECT-with-dependencies.jar" "mypackage.MakeCall"
```
