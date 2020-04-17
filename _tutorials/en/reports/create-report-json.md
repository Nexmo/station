---
title: Create a report using command line
description: In this step you learn how to create a report using the command line tool, curl.
---

To create a report, send a `GET` request to `https://api.nexmo.com/v2/reports/records`.

The parameters that you include in the request will determine which records are returned.

To obtain a specific record use the ID filter. For example, use the following request to view a status of SMS message with ID `13000000C7FE9025`:

```
curl -X GET -u $API_KEY:$API_SECRET "https://api.nexmo.com/v2/reports/records?account_id=TARGET_API_KEY&product=SMS&direction=outbound&include_message=true&id=13000000C7FE9025"
```

> **NOTE:** `TARGET_API_KEY` can be either your primary account or one of your subaccounts.

To obtain records within a specific time period use the `date_start` and `date_end` filters. The records returned describe all API requests that Nexmo received from you within this time period. For example, use the following request to view SMS messages sent from your Nexmo Account in a 5-minute window between `2020-04-02T12:00:00Z` and `2020-04-02T12:05:00Z`:

```
curl -X GET -u $API_KEY:$API_SECRET 'https://api.nexmo.com/v2/reports/records?account_id=TARGET_API_KEY&product=SMS&direction=outbound&include_message=true&date_start=2020-04-02T12:00:00Z&date_end=2020-04-02T12:05:00Z'
```

> **NOTE:** `date_end` must be within 1 hour of `date_start`.