---
title: Building Blocks
navigation_weight: 3
---

# Building Blocks

Building blocks provide a quick reference to how to achieve a specific single concern task. They are designed to be easily readable and light on content to allow the user to context switch between the documentation and their codebase without too much distraction. Below you'll find a typical structure of how a building block should be structured.

**✅ Examples of when a building block is appropriate**

- How to send an SMS
- Making an outbound call
- Send verification code
- Get details about a phone number
- Buy a number

**❎ Examples of when a building block is not appropriate**

- Accepting an inbound call

    *This topic requires more setup than is appropriate for a building block and would more appropriately be a guide.*

- Two factor authentication

    *Although the components of this should be building blocks the subject in itself is too involved for a building block.*

## Anatomy of a building block

Let's look at an example building block and the sections that come together to create a building block.  Detailed information about each section follows.

![Title and opening statement of building block](/assets/images/contributing/bb-opening-border.png)

The first part of the file is the **title** and opening remarks of the building block.  You can edit this in the [markdown file for each building block](#building-block-markdown-file).

![Table of placeholder variables](/assets/images/contributing/bb-placeholders-border.png)

The **placeholder variables** are also in the [markdown file for each building block](#building-block-markdown-file), these values should be the same in every code block.

![Tabbed content](/assets/images/contributing/bb-tabbed-examples-border.png)

The examples themselves are different for each language.  The **tabbed sections** here are defined by which [per-language config files](#language-config-files) are available at the path configured in the [markdown file for each building block](#building-block-markdown-file).  If the file exists, then there will be a tab for it.

![Setup steps](/assets/images/contributing/bb-prereqs-border.png)

The **pre-requisites and installation steps** are automatically generated from the information in the [per-language config files](#language-config-files), by declaring a list of variables and in most cases showing how to create an application.  See the details for each language for full details of the options available.

![Code sample](/assets/images/contributing/bb-write-the-code-border.png)

The [code sample](#source-code) itself lives on an external repository that holds a full, working version of the example.  This is defined in the [per-language config files](#language-config-files) for each building block language example.

![Execution instructions](/assets/images/contributing/bb-run-the-code-border.png)

The instruction for running the application that has been created is configured in the [per-language config files](#language-config-files).

![Demo section](/assets/images/contributing/bb-try-it-out-border.png)

With the application running, describe how to interact with it.  This should be the same for all the languages and is defined in the [markdown file for each building block](#building-block-markdown-file).

![Further reading](/assets/images/contributing/bb-further-reading-border.png)

Finally, any additional links and resources may also be added to the [markdown file for each building block](#building-block-markdown-file). 


## File locations for building blocks

### Building block markdown file

This is the entry point that causes the building block to exist in the first place.  It's a markdown file in the `building_blocks` directory for the documentation section it applies to, with a path such as `/_documentation/voice/voice-api/building-blocks/my_awesome-block.md`.

It contains some basic front matter include the page title and navigation weight:

```
---
title: Quick howto on a simple thing
navigation_weight: 5
---
```

This file has the title, and some opening content about what the building block does or what it's for.  Most users may have come from another part of the docs, such as a specific guide, but others may have landed here via search and will loack context.

The placeholders are also included here in the markdown file for the building block itself.

Within the building block markdown file, we define a "building block" - this is what renders everything inside the tabbed content block.

````
```building_blocks
source: '_examples/concepts/sample-building-block'
application:
  name: 'Example Application'
```
````

This block points to the directory that contains the per-language config files for the tabbed content block.  The settings here are combined with the per-language config files, so it's possible to set common settings in this section.

The only other sections coming from this file are the "Try it out" and "Further reading" ones.

### Language config files

For each of the tabs in the tabbed content block, the content is controlled entirely by a language-specific yaml file.  This yaml file will be in the location specified by the `source` field in the `building_blocks` code sample, and will be named for the language it covers, such as `ruby.yml` or `python.yml`.

The options available in these config files vary by language but lead to a very consistent output format.  Here's an example from one of our voice applications.

```
---
title: Java
language: java
dependencies:
    - 'com.nexmo:client:latest.release'
code:
    source: .repos/nexmo-community/nexmo-java-quickstart/src/main/java/com/nexmo/quickstart/voice/TransferCall.java
    from_line: 42
    to_line: 42
client:
    source: .repos/nexmo-community/nexmo-java-quickstart/src/main/java/com/nexmo/quickstart/voice/TransferCall.java
    from_line: 17
    to_line: 22
run_command: java-ide
file_name: TransferCall.java
unindent: true
```

These options control everything from the pre-requisites and setup steps, to showing and running the code.  There are some settings which are the same for all languages, and others which differ between languages.  These are covered in the sections below.

#### Common Options

These options apply to all languages.

Field | Description 
-- | -- 
`title` | Displayed on the tab, usually the title-cased language name
`language` | The language used, usually lowercase language name (nodejs is spelled "node")
`unindent` | If the code samples have leading tabs, remove as many as make the included code not be indented

> If the same value for these options would apply to every language example, it can be set in the building block definition in the overall building block markdown file.

#### C# Options

#### Java Options

#### Node Options

#### PHP Options

#### Python Options

#### Ruby Options

### Source Code

The code displayed within the tabbed examples belongs in external repositories; these are our "Quick Start" repositories on the [Nexmo Community GitHub organisation](https://github.com/nexmo-community).  The directory structure follows that of the `_documentation` directory on Nexmo Developer.

The examples on the Quick Start repositories should be self-contained and executable.  In the building blocks, we only include the section(s) that are directly relevant to the task that the building block is intended to illustrate.



