---
title: Styleguide
---

# Styleguide

Here is a complete overview of the basic markdown and custom plugins that Nexmo Developer supports.

We use plugins sparingly to extend functionality where the only other option would be HTML.

You can find this document in `/app/views/static/styleguide.md`. The side navigation has been left present to be an accurate representation of the content width.

There is no markdown syntax in here as this document is rendered with the same engine and no support exists for escaping markdown. Examples would ultimately be rendered. To understand recursion you must first understand recursion.

## Typography

**Headings**

# I am a H1
## I am a H2
### I am a H3

> Custom extension: Headings have their own slugified ID's for deep linking. For example the `h1` has an ID of `i-am-a-h1`

**Paragraphs**

Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit. Cras mattis consectetur purus sit amet fermentum. Donec id elit non mi porta gravida at [eget metus](#). Vestibulum id ligula porta felis euismod semper. Donec id elit non mi porta gravida at eget metus. Cras mattis consectetur purus sit amet fermentum. Sed posuere consectetur est at lobortis.

**Inline styles**

Text can be **bold**, *italic* or ***bold and italic***. You could use ~~strikethrough~~ but please don't.

You can define inline `code block` with backticks.

This is a [link](http://google.com) to Google.

> **Note**: You can use a `>` to specify a blockquote. We use these for tips like this.

## Images

![Please always add alt-text](https://media.giphy.com/media/pDTLSpqNvNxlu/giphy.gif)

> Images should be used sparingly, try to avoid using screenshots that might go out of date.
>
> Also... Please ALWAYS write descriptive alt text.

## Lists

**Unordered Lists**

> List items have `*` in front of them.
>
> Indentations are 4 spaces.

* Alpha
* Bravo
    * Charlie
    * Delta
        * Echo
    * Foxtrot
* Golf

**Ordered Lists**

> List items have `1.`, `2.`, `3.` etc in front of them.
>
> Indentations are 4 spaces.

1. One
2. Two
    1. Three
    2. Four
        1. Five
    1. Six
3. Seven

## Code

**Code blocks**

Normal code blocks are specified using three backticks at the start and end.

```
This is a normal code block.

It does not specify a language so is not syntax highlighted.
```

Here is some Ruby:

```ruby
def print_hi(name)
  puts "Hi #{name}"
end

print_hi('Adam')
#=> prints 'Hi Adam' to STDOUT.
```

**Tabbed Examples (custom plugin)**

For tabbed code we use a custom plugin.

> You'll have to view the `styleguide.md` source to see how since showing you the syntax would result in it being processed.

```tabbed_examples
source: '/_examples/messaging/sending-an-sms/basic'
```

**Tabbed Examples (custom plugin) + pulling code in from external repository**

For tabbed code we use a custom plugin.

> You'll have to view the `styleguide.md` source to see how since showing you the syntax would result in it being processed.

```tabbed_examples
tabs:
  Ruby:
    source: .repos/nexmo-community/nexmo-ruby-quickstart/sms/send.rb
    from_line: 8
```

## Tables

> Pipes should only be between cells. Two hyphens `--` should be used to 'underline' the headings.
>
> You'll have to view the `styleguide.md` source to see how since showing you the syntax would result in it being processed.

Key | Description
-- | --
`TO_NUMBER` | The number you are sending the SMS to
`API_KEY` | You can find this in your [account overview](https://dashboard.nexmo.com/account-overview)
`API_SECRET` | You can find this in your [account overview](https://dashboard.nexmo.com/account-overview)

## Tabbed Content (custom plugin)

```tabbed_content
source: '/_examples/styleguide/tabbed-content'
```

## JS Sequence Diagram (custom plugin)

> You'll have to view the `styleguide.md` source to see how since showing you the syntax would result in it being processed.

```js_sequence_diagram
Andrew->China: Says Hello
Note right of China: China thinks\nabout it
China-->Andrew: How are you?
Andrew->>China: I am good thanks!
```

## Modals (custom plugin)

Sometimes content is too verbose to put on the surface (particularly if it's in a table). You can include a file in a modal:

Why not @[give it a try](/_modals/styleguide/example.md) now?

## Languages (custom plugin)

Inline [IETF language tag](https://en.wikipedia.org/wiki/IETF_language_tag) support, using both primary language tags and subtags, is provided using the following syntax.

Language | Key | Text
-- | -- | --
English | none | Hello World
Spanish | `es` | [Hola Mundo](lang: 'es')
French | `fr` | [Bonjour le monde](lang: 'fr')
Brazilian Portuguese | `pt-BR` | [Olá Mundo](lang: 'pt-BR')
Hebrew | `il` | [שלום עולם](lang: 'il')
