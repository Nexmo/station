---
title: Delivery receipts
---

# Delivery receipts

When Nexmo sends an SMS to a carrier, the carrier should return a delivery receipt (DLR). Carriers send delivery receipts at a moment of their choice, they do not have to wait for delivery confirmation.

Delivery receipts are either:

* Carrier - returned when the SMS is received by the telecommunications service providers.
* Handset - returned when the message is received on your user's handset.

If your message is longer than a single SMS, carriers should send a DLR for each part of the concatenated SMS. Handset delivery receipts for a concatenated message are delayed. This is because each part of the concatenated message takes about 10 seconds to be processed by the handset.

In practice, some carriers either do not send the delivery receipt or send a fake. Depending on the country you are sending to, Nexmo cannot be 100% certain that a *successfully delivered* delivery receipt means that the message reached your user.

Before you start your messaging campaign:

1. Check the [Country Specific Features](#country-specific-features) for the countries you are sending to.
2. If the country you are sending to does not supply reliable DLRs, use [Conversion API](/messaging/conversion-api/overview) so Nexmo has more data points to ensure the best routing.
