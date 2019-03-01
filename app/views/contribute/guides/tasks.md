---
title: Tasks
---

# Task Driven Content

We're experimenting with task driven content on Nexmo Developer. This is a brief guide to how it looks and how to create a new task.

In this example, we're going to create a flow that talks users through making their first outbound voice call with Nexmo.

![Outbound Call Example](/assets/images/contributing/task-example.png)

### Task Config File

Task configuration files live in `config/tasks` and the name of the file is used as the name of the task in the URL.

For example the configuration for, `https://developer.nexmo.com/task/create-an-outbound-call` lives at `config/tasks/create-an-outbound-call.yml`.

```yaml
title: Create an Outbound Call
description: Build a server to serve an Answer URL and trigger an outbound voice call
product: voice/voice-api

tasks:
  - create-nexmo-account
  - application/create-voice
  - voice/serve-ncco
  - voice/outbound-call
```

> At the moment the `description` and `product` are not used, but they will be used in future updates (e.g. section scoped navigation) so please include them in your tasks.

The core part of a task definition is the `tasks` section. This is a list of subtasks that are combined to produce a single parent task. In this case the user needs to:

* Create a Nexmo account
* Create a voice application
* Serve an NCCO using their language of choice
* Trigger an outbound phone call

Each of these files live in the `_tasks` folder and are markdown files. For example `application/create-voice` lives at `_tasks/application/create-voice.md` with the following contents:

```yaml
---
title: Create a Voice application
description: Create a Voice application, with an answer_url and event_url
---

# Content goes here
```

### Content Reuse

The idea behind having standalone subtask files is that we can define each task once (e.g. create a voice application) and then reference it in every task that requires a voice application. For example, if we wanted to show how to receive a voice call we may use the following set of tasks:

```yaml
tasks:
  - create-nexmo-account
  - application/create-voice
  - number/purchase
  - number/link-application
  - voice/serve-ncco
```

In this task flow we already had most of the content and we only had to write new blocks for purchasing and linking a number to an application

### Adding more context

Although we want as much content reuse as possible, each task we want a customer to perform will need some context. To provide this, you can define an `introduction` and `conclusion` in a task config file (`config/tasks/task-name.yml`):

```yaml
title: Create an Outbound Call
description: Build a server to serve an Answer URL and trigger an outbound voice call
product: voice/voice-api

introduction:
  title: Getting started with the Nexmo Voice API for outbound calls
  description: How does the Nexmo Voice API work?
  content: |
    The Nexmo Voice API is a fantastic tool for creating outbound voice calls that use Text-To-Speech to
    speak generated content to your customers.
    
    We use human sounding voices in a variety of different languages to make sure your customers get a
    customised experience.

tasks:
  - create-nexmo-account
  - application/create-voice
  - voice/serve-ncco
  - voice/outbound-call

conclusion:
  title: What's next?
  description: What else can you do with the Voice API?
  content: |
    Congratulations! You just made your first voice call with the Nexmo Voice API. Wondering where to go next?
    
    How about taking a look at how to [connect another number to a call](#), [mute a participant](#) or [end a call](#)

```

This content is provided directly in the task configuration file as it is specific to the current task and is not intended to be reused. If you need to reuse a conclusion, create a new task type at `_tasks/conclusion/voice` and add it to the list of `tasks`
