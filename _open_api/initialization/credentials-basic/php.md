---
language: php
---

#### Initialize the library

```php
<?php

$client = new Nexmo\Client(
  new Nexmo\Client\Credentials\Basic(
    API_KEY,
    API_SECRET
  )
);
```
