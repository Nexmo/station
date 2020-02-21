---
title: Tutorials
---

# Tutorials

Ste-by-step procedures are documented using tutorials in Nexmo Developer. This is a brief guide to how it looks and how to create a new tutorial.

In this example, you are going to create a flow that takes users through sending a Facebook message with failover using the Dispatch API.

![Sending a message with Dispatch API](/assets/images/contributing/task-example.png)

### Tutorial Config File

Tutorial configuration files live in `config/tutorials` and the name of the file is used as the name of the tutorial in the URL.

For example, the configuration for `https://developer.nexmo.com/tutorials/sending-facebook-message-with-failover` lives at `config/tutorials/sending-facebook-message-with-failover.yml`. The contents of the config file is shown here:

```yaml
title: Sending a Facebook message with failover
description: The Dispatch API provides the ability to create message workflows with failover to secondary channels. This task looks at using the Dispatch API to send a Facebook message with failover to the SMS channel.
products:
  - dispatch

introduction: 
  title: Introduction to this task
  description: This task shows you how to use the failover functionality of the Dispatch API.
  content: |
    # Introduction
    The Dispatch API features workflows with automatic failover. In this task you see how to send a Facebook Messenger message with automatic failover to SMS.

    > **NOTE:** This task assumes you have already created a Facebook Profile and a Facebook Page.

prerequisites:
- create-nexmo-account
- install-nodejs
- install-nexmo-cli-beta
- install-node-sdk-beta
- olympus/configure-webhooks
- olympus/write-webhook-server
- olympus/test-webhook-server

tasks:
- olympus/create-application
- olympus/link-facebook-page
- olympus/send-facebook-failover

conclusion:
  title: What's next?
  description: What else can you do with the Dispatch API?
  content: |

    # What's next?
    You can do a lot more with the Dispatch API.

    See [Dispatch API documentation](/dispatch/overview) and [a multi-user, multi-channel workflow Dispatch use case](/use-cases/dispatch-user-fallback).

```

You see the `prerequisites` section which is a list of files that provide Markdown content for each of the prerequisites list:

![Prerequisites](/assets/images/contributing/task-prereqs.png)

Clicking on any prerequisite displays the content.

The main steps of the tutorials are defined in the `tasks` section. This is a list of subtasks, or steps, that are combined to produce a single parent tutorial. In this case the user needs to:

1. Create an application
2. Link their Facebook page to Nexmo
3. Send a message

Each of these files live in the `_tutorials` folder and are written using Markdown. For example `olympus/create-application` lives at `_tutorials/olympus/create-application.md` with the following contents:

```yaml
---
title: Create a Messages and Dispatch Application
description: In this step you learn how to create a Messages and Dispatch Application. A Messages and Dispatch application has a message status webhook and inbound message webhook, where the inbound message is of type `whatsapp`, `messenger` or `viber_service_msg`. Inbound SMS has to be handled through your account-level SMS webhook.
---

# Create your Nexmo Messages and Dispatch Application

Rest of content goes here.
```

### Content Reuse

The idea behind having standalone step files is that you can define each task once, such as for create application, and then reference it in every tutorial that requires a Messages and Dispatch API application.

Being able to reuse content in this way leads to far greater consistence, more rapid documentation development, and ease of maintenance.

### Adding more context

Although you want as much content reuse as possible, each step you want a customer to perform will need some context. To provide this, you can define an `introduction` and `conclusion` in a tutorial config file (`config/tutorials/task-name.yml`):

```yaml
title: Sending a Facebook message with failover
description: The Dispatch API provides the ability to create message workflows with failover to secondary channels. This task looks at using the Dispatch API to send a Facebook message with failover to the SMS channel.
products:
  - dispatch

introduction: 
  title: Introduction to this task
  description: This task shows you how to use the failover functionality of the Dispatch API.
  content: |
    # Introduction
    The Dispatch API features workflows with automatic failover. In this task you see how to send a Facebook Messenger message with automatic failover to SMS.

    > **NOTE:** This task assumes you have already created a Facebook Profile and a Facebook Page.

...

conclusion:
  title: What's next?
  description: What else can you do with the Dispatch API?
  content: |

    # What's next?
    You can do a lot more with the Dispatch API.

    See [Dispatch API documentation](/dispatch/overview) and [a multi-user, multi-channel workflow Dispatch use case](/use-cases/dispatch-user-fallback).
```

This content is provided directly in the tutorial configuration file as it is specific to the current tutorial and is not intended to be reused.
