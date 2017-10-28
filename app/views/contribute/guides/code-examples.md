---
title: Code Examples
---

# Contributing Code Examples

Nexmo Developer hosts many code examples, we endeavour to make the as consistent as possible. You should follow this guide when contributing code examples to the building blocks repositories or directly to Nexmo Developer.

## Placeholders

The following values should be used as placeholders in code examples. They can be specified assigned as constants out of the range of view of the rendered code to allow the code to be executed whist providing an obvious placeholders for the reader.

Key | Description | User customisation (future)
-- | -- | --
`NEXMO_API_KEY` | The users Nexmo API Key | ✅
`NEXMO_API_SECRET` | The users Nexmo API Key | ✅
`NEXMO_NUMBER` | The virtual number that the user holds with Nexmo | ❓
`YOUR_NUMBER` | The number that the user owns or wants to communicate with | ❓
`NEXMO_APPLICATION_PRIVATE_KEY` | Represents a string of the actual private key | ❎
`NEXMO_APPLICATION_PRIVATE_KEY_PATH` | Represents a string that relates to the private key directory | ❎

### Future auto-magical user customisation

In the future we will customise code examples to the logged in user for example by adding API key and secret to the examples. To do this we need to be careful about how we use placeholders.


#### ✅ Good

{column:1/2}
This input:

```javascript
const nexmo = new Nexmo({
  apiKey: NEXMO_API_KEY,
  apiSecret: NEXMO_API_SECRET
})
```
{end}
{column:2/2}
Or this input:

```javascript
const nexmo = new Nexmo({
  apiKey: 'NEXMO_API_KEY',
  apiSecret: 'NEXMO_API_SECRET'
})
```
{end}


Would be converted to this into something like:

```javascript
const nexmo = new Nexmo({
  apiKey: 'abc123',
  apiSecret: 'abcdef123456789'
})
```

#### ❎ Bad

This input:

```javascript
NEXMO_API_KEY = process.env.NEXMO_API_KEY
NEXMO_API_SECRET = process.env.NEXMO_API_SECRET

// Something else
```

Would be converted to this invalid example:

```javascript
'abc123' =  process.env.'abc123'
'abcdef123456789' = process.env.'abcdef123456789'

// Something else
```

### SMS Specific

#### Message Body

```
A test SMS sent [demonstrating <feature>] using  the Nexmo SMS API
```

#### SenderID

```
Acme Inc
```

### NCCO examples

Below you can find static NCCO's that can be used in code examples. The source of these can be found in the `/public/ncco` directory of Nexmo Developer.

Example | URL
-- | --
Basic text-to-speech | <https://developer.nexmo.com/ncco/tts.json>

## Code

### Length

Where possible code should be kept to a maximum of 80 characters per-line.

The capacity before scrolling occurs is 101 characters however not all code examples are as wide as this.

```
----------------------- I am a line with 80 characters ------------------------
--------------------------------- I am a line with 101 characters ----------------------------------
```

### Linters, Formatters & Code Style Guides

Code throughout Nexmo Developer should be consistent. To help achieve this code examples should be tested with the following tools and against guides on their default configuration:

Language | Resource | Configuration
-- | -- | --
Node | [Standard JS](https://standardjs.com/) | Non configurable
Java | - | -
.NET | - | -
PHP | [PHPCS]ahttps://github.com/squizlabs/PHP_CodeSniffer#installation) | [PSR-2](https://github.com/Nexmo/nexmo-php/blob/develop/phpcs.xml)
Python | [YAPF](https://github.com/google/yapf) | Default
Ruby| [Rubocop](https://github.com/bbatsov/rubocop) | Default
