---
title: Write the docs
---

# Write the docs

This document provides a guide for writing documentation for Nexmo Developer.

## What should I use in place of variables?

When working with keys, phone numbers or accounts we should always be clear
about our intent for the customer to replace such values with their own. Use the
following as a guideline:

### Keys & Placeholders

Key | Markdown Value | Rendered Value  <small>(if different)</small>
-- | -- | --
API Key | `$API_KEY` | `API_KEY`
API Secret | `$API_SECRET` | `API_SECRET`
From Number | `FROM_NUMBER` | -
To Number | `TO_NUMBER` | -
Timestamp | `2020-01-01 12:00:00` | -
Epoch | `1577880000` | -
HTTP Method | ``[GET]`` or ``[POST]`` | [GET] or [POST]
HTTP Response | `` `200 OK` `` or §§ `` `404 Not Found` `` | `200 OK` or §§ `404 Not Found`

> *Note*: When there is a `$` proceeding the value can later be used to indicate
> a values that we later will be dynamic. For example `$API_KEY` would become
> the logged in users actual API Key or just `API_KEY` if they are not signed in.

When using a real number is not avoidable for example when listing out the result
of `nexmo numbers:list` in the CLI use the following numbers:

### Numbers

#### US Numbers

Human readable format | E.164 format
-- | --
`(415) 555-0100` | `14155550100`
`(415) 555-0101` | `14155550101`
`(415) 555-0102` | `14155550102`
`(415) 555-0103` | `14155550103`
`(415) 555-0104` | `14155550104`
`(415) 555-0105` | `14155550105`

#### GB Numbers

Human readable format | E.164 format
-- | --
`020 7946 0000` | `442079460000`
`020 7946 0001` | `442079460001`
`020 7946 0002` | `442079460002`
`020 7946 0003` | `442079460003`
`020 7946 0004` | `442079460004`
`020 7946 0005` | `442079460005`

#### GB Mobile Numbers

Human readable format | E.164 format
-- | --
`07700 900000` | `447700900000`
`07700 900001` | `447700900001`
`07700 900002` | `447700900002`
`07700 900003` | `447700900003`
`07700 900004` | `447700900004`
`07700 900005` | `447700900005`

### Known incorrect uses

The following is a list of values that should be removed if found.

```
n3xm0rocks
TwoMenWentToMowWentTOMowAMeadowT
12ab34cd
44123456789
2020-01-01 12:00:00
```
