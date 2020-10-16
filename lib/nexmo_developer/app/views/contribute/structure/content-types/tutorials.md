---
title: Tutorials
navigation_weight: 4
---

# Tutorials

A tutorial is a complete walkthrough of how to build something practical. It is  step-by-step and self-contained example, providing all the necessary content inline and focused on a single, well-defined outcome. Tutorials support multiple programming languages, if that's what you need.

> **Note**: Please read our [Tutorials and Use Cases guide](/contribute/guides/tutorials-and-use-cases) to help you decide whether a tutorial is the best fit for your content.

The following screenshot illustrates the appearance of a tutorial:

![Sending a message with Dispatch API](/assets/images/contributing/task-example.png)



## Opening

Explain what the problem is and outline the steps that you'll take to overcome it in bullet points.

> Note: The opening has no heading as the heading should serve this purpose.

## Guide

Every tutorial has its own problem to solve. Use headings and sections that align with the steps one would take to overcome the problem.

## Conclusion

Reflect on:

* What you have done
* How you could extend on what you have learnt

Point to resources:

* Guides - Guides covering the concepts used in the tutorial.
* Code Snippets - cover specific bits of code to do single function operations.
* API Reference - Given that the tutorial is opinionated, provide this as a resource to allow the user to see what other options are available to them.
* Tutorials - Other relevant tutorials.

## External Tutorials

We can include tutorial entries for content that is actually elsewhere, such as on the blog. This is useful for bringing Tutorial Tuesday content and X with Y posts into the developer portal so that users can find other content that may be of interest.

To create an external tutorial, create a markdown file with _just_ frontmatter. It should look something like this:

```
---
title: Anything-to-SMS with IFTTT and Nexmo
products: messaging/sms
description: This is a description that will be shown on the tutorials list page
external_link: https://www.nexmo.com/blog/2018/09/18/anything-to-sms-ifttt-nexmo-dr/
languages:
    - Node
---
```

These will be rendered as tutorials in the tutorial listing pages, but when clicked the user will go to the original source of the content.
