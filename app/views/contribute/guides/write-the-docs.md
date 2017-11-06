---
title: Write the docs
---

# Write the docs

This document provides a guide for writing documentation for Nexmo Developer.

## What should I use in place of variables?

When working with keys, phone numbers or accounts we should always be clear about our intent for the customer to replace such values with their own. Use the following as a guideline:

### Keys & Placeholders

Key | Markdown Value | Rendered Value  <small>(if different)</small>
-- | -- | --
Timestamp | `2020-01-01 12:00:00` | -
ISO8601 Timestamp | `2020-01-01T12:00:00.000Z` | -
Epoch | `1577880000` | -
HTTP Method | ``[GET]`` or ``[POST]`` | [GET] or [POST]
HTTP Response | `` `200 OK` `` or §§ `` `404 Not Found` `` | `200 OK` or §§ `404 Not Found`
Balance | `3.14159` | -
Latency | `3000` | -
UUID | `aaaaaaaa-bbbb-cccc-dddd-0123456789ab` | -
SNS ARN | `arn:aws:sns:us-east-1:01234567890:example` | -

When using a real number is not avoidable for example when listing out the result of `nexmo numbers:list` in the CLI use the following numbers:

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
