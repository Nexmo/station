---
title: Landing Pages
navigation_weight: 6
---

# Config Driven Landing Pages on Nexmo Developer

## Table of Contents

- [Table of Contents](#table-of-contents)
- [Introduction](#introduction)
- [Defining the Layout of the Config File](#defining-the-layout-of-the-config-file)
- [Content Types](#content-types)
  - [Action Button](#action-button)
  - [API List](#api-list)
  - [Call To Action](#call-to-action)
  - [Client SDK Card](#client-sdk-card)
  - [Contact Support](#contact-support)
  - [Events](#events)
  - [GitHub Repo](#github-repo)
  - [Header](#header)
  - [Headshot](#headshot)
  - [HTML](#html)
  - [Join Slack](#join-slack)
  - [Line Divider](#line-divider)
  - [Linked Image](#linked-image)
  - [Products](#products)
  - [Section Header](#section-header)
  - [Sessions](#sessions)
  - [Structured Text](#structured-text)
  - [Submit your Idea Form](#submit-your-idea-form)
  - [Table](#table)
  - [Team Members](#team-members)
  - [Text](#text)
  - [Tutorial](#tutorial)
  - [Unordered List](#unordered-list)
  - [Warning Callout](#warning-callout)
  - [Write for Nexmo](#write-for-nexmo)

## Introduction

Config driven landing pages allow you to create pages with the content you need quickly and painlessly. Each landing page is generated from a [YAML](https://yaml.org/start.html) file in `/config/landing_pages/`. The name of the YAML file should be the same name as the URL you want for the landing page. For example, if you want a PHP language landing page that can be accessed at `https://developer.nexmo.com/php` then you need to name your YAML file `php.yml`.

Event landing pages should be added to `/config/landing_pages/e`, unless it is a Vonage event, in that case it can be added to `/config/landing_pages` directly. The event landing pages added to the `/e` sub-folder can be accessed at `https://developer.nexmo.com/e/#{name-of-event}`.

The config file represents rows and columns on a website with pre-defined content blocks. You can design your landing page with the visual layout that best works for your information and use the pre-defined content blocks to give your content shape and design.

Let's explore the building of a config file and then we will detail each content block and the data it accepts.

## Defining the Layout of the Config File

<img src="/assets/images/contributing/landing_page_screenshots/landing_page_layout.png" width=400>

Each config file represents the visual layout of a landing page, including the number of rows and the amount of columns in each row, along with the actual information in the landing page. A config file begins with `page:` that designate the `key` name of `page` and the colon is the division between the `key` name and the `value`. Within a YAML file, to specify an array of data one uses the `-` before the `key` name. This is an important element of the config file, as the data of `page` and `row` are held in arrays. Thus, the following will produce a single row with two columns:

```yaml

page:
  - row:
    - width: 2
      column:
    - column:

```

A column can either begin with the keyword of `column` or the `key: value` pair of `width: integer`. The `width` value specifies how much of the row you would like that column to fill. Width is designated as a number between 1-4. If you do not specify a `width` the layout will default to a dynamically rendered arrangement of each column taking up an equal amount of space. The `column` keyword, unlike the `width` keyword is mandatory, so even if you specify a `width` value, you still must begin the next line with `column`.

What about other layout possibilities? This is how you would define a layout of 2 rows with 3 columns in the first and 1 column in the second:

```yaml

page:
  - row:
    - width: 1
      column:
    - width: 2
      column:
    - width: 1
      column:
  - row:
    - column:

```

At this point we are ready to detail each content block type and the data associated with it.

## Content Types

### Action Button

<img src="/assets/images/contributing/landing_page_screenshots/action_button.png" width=200>

The `action_button` content block creates a clickable linked HTML button you can add to the landing page. The YAML config for an action button is the following:

```yaml

- type: action_button
    action_button:
      text: # Text for the button (i.e. "Apply now!")
      url: # The URL for the button (i.e. "#submit-your-idea")

```

The `action_button` supports the following optional parameters:

```yaml

type: # "secondary" or "primary", with "primary" being the default. 
large: # true or false, with false being the default.
center_button: # true or false, with false being the default.

```

### API List

The `api_list` content block allows you to render a list of APIs you wish to show. It is suitable for an index type view of a collection of APIs.

The content block takes the following required parameters:

```yaml
- type: api_list
  api_list:
    header:
      title: # Header title for the view
    num_of_columns: # The number of columns you wish to split the API listings into (i.e. 2 or 3)
    categories:
      - new_column:
        - title: # The category title for a collection of APIs, (i.e. 'Messaging')
          icon:
            color: # The color of the icon to represent the category (i.e. purple)
            name: # The name of the Volta icon (i.e. 'Vlt-icon-message')
          apis: # A list of the APIs wto show in this category collection
            - title: # Name of the API (i.e. 'Messages API')
              path: # The relative path to the API documentation (i.e. 'api/messages-olympus')
              description: # A body of text to describe the API
```

Additionally, you can optionally add a badge next to the name of each API representing a special status like "Beta" or "Developer Preview", You do so by adding two more keys in the API category:

```yaml
apis:
  - title:
    path:
    description:
    badge:
      name: Beta
      color: green
```

### Call To Action

<img src="/assets/images/contributing/landing_page_screenshots/call_to_action.png" width=200>

The `call_to_action` content block creates a specific layout of text with an icon. You might want to use the `call_to_action` to draw attention to a featured area of Nexmo Developer, like our SDKs and Tools, for example. The `call_to_action` block requires the following parameters:

```yaml

- type: call_to_action
  call_to_action:
    title: # Title for the content (i.e. "SDKs and Tools")
    icon: 
      name: # Name of icon to use (i.e. "icon-design-tools")
      color: # Color of icon (i.e. "blue-dark")
    url: # Link the call to action directs to (i.e. "/tools")

```

In addition, you can also specify an optional `subtitle` parameter that gives you the opportunity to provide more descriptive text for your call to action. (_Note: You can use markdown in the `subtitle` to further style the content_.) For example, the following would render with a line break between `with` and `Nexmo APIs`:

```yaml

subtitle: "The Nexmo libraries allow you to get up and running with<br> Nexmo APIs quickly in your language of choice."`

```

### Client SDK Card

The `client_sdk_card` content block provides a Client SDK card to display client SDK information. The content block renders a title, icon and text and link to SDK documentation. All content types are required. 

```yaml

- type: client_sdk_card
  client_sdk_card:
    name:
      content:
      color:
    icon:
      name:
    text:
      content:
    documentation_url:

```
   

### Contact Support

<img src="/assets/images/contributing/landing_page_screenshots/contact_support.png" width=400>

The `contact_support` content block is a pre-defined set of information that takes no parameters. Once you add it to your config file, it will populate with information about getting in touch with Nexmo for support. To add it to your config file, just reference it:

```yaml

- type: contact_support

```

### Events

<img src="/assets/images/contributing/landing_page_screenshots/events.png" width=400>

The `events` content block is a pre-defined set of information that takes no parameters. Once you add it to your config file, it will populate with information on upcoming DevRel Community events, with a generated Google Maps with markers for each event. To add it to your config file, just reference it:

```yaml

- type: events

```

### GitHub Repo

<img src="/assets/images/contributing/landing_page_screenshots/github_repo.png" width=200>

The `github_repo` content block lets you reference a GitHub repository on your landing page. It will display the name of the repository, the language, the number of stars and number of forks. The block will link to the repository directly on GitHub. It requires the following parameters:

```yaml

- type: github_repo
  github_repo:
    repo_url: # Link to repository on GitHub
    github_repo_title: # Name of repository (i.e. "Nexmo REST API client for .NET")
    language: # Language of code in repository (i.e. ".NET")

```

Optionally, you can also provide a `badge_url` to link to the Version Badge of the library. The parameter can be provided in the following manner:

```yaml

- type: github_repo
  github_repo:
    repo_url:
    badge_url: # Example: //badge.fury.io/gh/nexmo%2Fnexmo-java.svg
    github_repo_title:
    language:

```

### Header

<img src="/assets/images/contributing/landing_page_screenshots/header.png" width=200>

The `header` block provides you with the layout for the landing page header content. The content consists of a title, with an icon, and an optional subtitle. You can specify the required parameters with the following:

```yaml

- type: header
  header:
    title: 
      text: # The header title text (i.e. "Write for Nexmo!")
    icon: 
      name: # Name of icon to use (i.e. "icon-rocket")
      color: # Color of icon (i.e. "blue")

```

There are also optional parameters for the `header` content block. You only need to specify values for these optional parameters if you want to change their defaults.

```yaml

title:
  text: # Header title
  align: # Text alignment, default is left-aligned if not defined (i.e. "center")
subtitle:
  text: # Subtitle text (i.e. "Teach others, grow as a writer, and help us build the next go-to destination...")
  align: # Subtitle text alignment, default is left-aligned if not defined (i.e. "center")
  type: # "large" or "small", default is small if not defined

```

Lastly, like the `call_to_action` subtitle, the text in the `header` subtitle is also capable of rendering markdown content.

### Headshot

<img src="/assets/images/contributing/landing_page_screenshots/headshot.png" width=200>

The `headshot` block provides a way of rendering a headshot on your landing page. The content consists of an image, an external url which the image is linked to, a name and a short description.  You can specify the required parameters with the following:

```yaml

- type: headshot
  headshot:
    name: # Name of the person in the image
    url: # Link to url
    img_src: # Link to image
    intro: # Short text rendered below the image

```

The `headshot` supports the following optional parameters:

```yaml

twitter: # twitter handle
github: # github handle
location: # where the person is based

```

### HTML

<img src="/assets/images/contributing/landing_page_screenshots/html.png" width=400>

The `HTML` content block provides you with a place to insert HTML code that does not fit any of the pre-defined content blocks. Its only required parameter is `content`:

```yaml

- type: html
  html:
    content: # Put HTML here (i.e. "This is a <strong>HTML</strong> example")

```

### Join Slack

<img src="/assets/images/contributing/landing_page_screenshots/join_slack.png" width=200>

The `join_slack` content block is a pre-defined styled invitation to join the Nexmo community Slack. It takes no parameters.

```yaml

- type: join_slack

```

### Line Divider

<img src="/assets/images/contributing/landing_page_screenshots/line_divider.png" width=400>

The `line_divider` content block is a pre-defined rendered line that can be used to visually divide a page. It takes no parameters.

```yaml

- type: line_divider

```

### Linked Image

<img src="/assets/images/contributing/landing_page_screenshots/linked_image.png" width=200>

The `linked_image` content block provides you with a format for an image that is linked to a URL. It takes the following parameters:

```yaml

- type: linked_image
  linked_image:
    image: # Link to image
    url: # Link to URL
    alt_text: # Alternate text if image cannot be rendered

```

### Products

<img src="/assets/images/contributing/landing_page_screenshots/products.png" width=200>

The `products` content block is a pre-defined listing of all of Nexmo's API products. It displays each one with links to tutorials, guides, code snippets and API reference. It takes no parameters.

```yaml

- type: products

```

### Section Header

<img src="/assets/images/contributing/landing_page_screenshots/section_header.png" width=200>

The `section_header` content block is used to create a header for a new section of content on your landing page. It renders a title with an icon. It takes the following parameters:

```yaml

- type: section_header
  section_header:
    title: # Title text goes here (i.e. "This is my title!")
    icon:
      name: # Name of icon (i.e. "icon-app")
      color: # Color of icon (i.e. "yellow")

```

### Sessions

<img src="/assets/images/contributing/landing_page_screenshots/sessions.png" width=400>

The `sessions` content block is a pre-defined set of information that takes no parameters. Once you add it to your config file, it will populate with links to past DevRel presentations. To add it to your config file, just reference it:

```yaml

- type: sessions

```

### Structured Text

<img src="/assets/images/contributing/landing_page_screenshots/structured_text.png" width=400>

The `structured_text` content block provides the styling for a block of text content that features a title and subsequent paragraphs of text. The text `content` can render markdown formatting. It takes the following required parameters:

```yaml

- type: structured_text
  structured_text:
    header: # Header text (i.e. "Who Owns Your Work?")
    text:
      - content: # Text content here, including markdown formatting (i.e. "You do!...")
        type: # "large" or "small"

```

You can specify as many `text` blocks as you would like. Each `text` block consists of `content` and `type`.

There is also an optional icon parameter for the `structured_text` content block. You can include it with the following:

```yaml

icon:
  name: # Icon name (i.e. "icon-merge")
  color: # Icon color (i.e. "blue")

```

### Submit your Idea Form
<img src="/assets/images/contributing/landing_page_screenshots/submit_your_idea_form.png" width=400>

The `submit_your_idea_form` content block creates a form that submits to a zapier's hook.
It requires the following parameters:

```yaml
- type: submit_your_idea_form
  submit_your_idea_form:
    header: "Submit Your Idea"
    icon:
      name: "icon-envelope"
      color: blue
```

### Table

<img src="/assets/images/contributing/landing_page_screenshots/table_partial.png" width=400>

 The `table` content block provides you with the ability to insert a table into your landing page, including with markdown formatting for the data in the table body. It is structured as follows:

 ```yaml
 - type: table
  table:
    head:
      - content: # First column header
      - content: # Second column header
    body:
      - row:
        - column: # First row, first column text
        - column: # First row, second column text
      - row:
        - column: # Second row, first column text
        - column: # Second row, second column text
 ```

 You can specify as many header `content` and body row `column` blocks as you would like.

### Team Members

The `team_members` content block provides you with a graphical representation of all the team members inside the `config/team.yml` file.

```yaml

- type: team_members

```

### Text

<img src="/assets/images/contributing/landing_page_screenshots/text.png" width=200>

The `text` content block provides you a space to insert plain text into your landing page, including with markdown formatting. It is structured as follows:

```yaml

- type: text
  text:
    content: # Text goes here (i.e. "This is a **Text** example")

```

### Tutorial

<img src="/assets/images/contributing/landing_page_screenshots/tutorial.png" width=200>

The `tutorial` content block lets you link to a tutorial and show a tutorial image, if one exists, and a tutorial title and description. The only parameter it requires is the `name` of the tutorial file on Nexmo Developer. The renderer will retrieve the rest of the details from the tutorial file itself:

```yaml

- type: tutorial
  tutorial:
    name: # Name of tutorial (i.e. two-factor-authentication-dotnet-verify-api)

```

### Unordered List

<img src="/assets/images/contributing/landing_page_screenshots/unordered_list.png" width=400>

The `unordered_list` content block lets you create a list of items and specify the shape of the list bullet item symbol. It accepts the following required parameters:

```yaml

- type: unordered_list
  unordered_list:
    list:
      - item: # First item in list
      - item: # Second item in list
      - item: # Third item in list
      - item: # Fourth item in list

```

As mentioned, you can also specify the shape of the bullet symbol with the `bullet_shape` parameter:

```yaml

bullet_shape: # Shape of bullet, if not defined it will default to a circle (i.e square)

```

### Warning Callout

The `warning_callout` content block provides an element to render a warning message. The block consists of a bordered message with an "i" information icon on the left-hand side and the warning text provided in the `content` parameter:

```yaml

- type: warning_callout
  warning_callout:
    content: # Warning message goes here

```

### Write for Nexmo

The `write_for_nexmo` content block will provide a call to action element to Write for Nexmo with a Developer Spotlight graphic on the left-hand side and text advertising the Write for Nexmo program on the left-hand side.

```yaml

- type: write_for_nexmo

```
