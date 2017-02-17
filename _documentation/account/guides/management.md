---
title: Management
---

# Account management

Dashboard is a web application that makes it easy to:

* Manage your account - setup and configure your Nexmo account
* Manage payments - top up your account balance, configure notifications and generate invoices
* Manage numbers - view and buy virtual numbers and short codes
* Analyse your API use - each product has a dedicated page you use to search and interpret the results of your API requests

(image: assets/images/dashboard.png)

The main tasks you achieve in Dashboard are:

* [Manage your account](#account_settings)
  * [Create and configure a Nexmo account](#setting-up-your-nexmo-account)
  * [Retrieve your account information](#retrieve-account-info)
  * [Manage users](#manage_users)
  * [Manage your profile](#manage_profile)
  * [Reset your password](#reset_password)
* [Manage payments](#payments)
  * [Add a payment method](#add_payment_method)
  * [Auto reload your account balance](#auto_reload )
  * [Setup balance notifications](#notifications)
  * [Delete a payment method](#delete_payment)
  * [Change balance currency](#change_balance_currency)
  * [Generate invoices](#invoices)
* [Manage numbers](#manage-numbers)
  * [Rent virtual numbers](#rent-vn)
  * [Configure a virtual number](#configure-vn)
  * [Setup Two-factor authentication](#shortcode)
  * [Setup event based alerts](#event_based_alerts)
* [Supported browsers ](#supported_browsers)

## Manage your account

You use Dashboard to:

* [Create and configure a Nexmo account](#setting-up-your-nexmo-account)
* [Retrieve your account information](#retrieve-account-info)
* [Manage users](#manage_users)
* [Manage your profile](#manage_profile)
* [Reset your password](#reset_password)


### Create and configure a Nexmo account

To create your free Nexmo account:

1. In your browser, navigate to [Dashboard](https://dashboard.nexmo.com/sign-up).
2. Add  your company information and click **Sign up**.
   Nexmo sends a PIN to your phone as a text message or automated phone call. The timeout for each verification attempt is 5 minutes.
   **Note**: you can associate a phone number with one account only. If your phone number is already associated with a Nexmo account you should [remove that phone number](#manage_profile) from the existing account.
3. In **Phone number verification**, enter the PIN sent to you by Nexmo and click **Verify**.
  You are logged into Dashboard and shown how to start developing with Nexmo. This page is displayed each time you login until you have made your first successful call with Nexmo API.

When you create your Nexmo account you are given €2 free test credit and your account is set in DEMO mode. You can use our products to send messages to up to 10 destination numbers, *[Nexmo DEMO]* is added to all the SMS you send. To move out of the Demo mode [add credit to your account](#add_payment_method).

For very few countries we cannot create a Nexmo account automatically. This is because of payment restrictions or legal trading restrictions for a US registered company.

### Retrieve your account information

To retrieve your Nexmo account information:

1. [Sign in](https://dashboard.nexmo.com/sign-in) to Dashboard.
3. On the top-right of Dashboard, click the arrow next to **&lt;username>**, then click **Settings**.
4. In **API settings**, you see your **API key** and **API secret**. You need these values for all API calls.

### Manage users

When you setup your Nexmo account you create your primary user. The primary user has unlimited access to your Nexmo products and services. That is:

* Manage payments and view your payment history
* Rent virtual numbers and short codes
* Search through your requests
* Configure Verify SDK
* Analyse your API use

After setup, you can add secondary users to your Nexmo account. A secondary account can have the same access rights as your primary account or a restricted set. For example, you can create a secondary account with no access to payments.

To create a secondary user:

1. [Sign in](https://dashboard.nexmo.com/sign-in) to Dashboard.
2. On the top-right of Dashboard, click the arrow next to **&lt;username>**, then click **Users**.
3. Click **Add User**.
4. Add the user information and choose the restrictions for a secondary account.
5. Click **Save**.
6. Your secondary user uses the temporary password they receive in an email to access Dashboard and create a new password.

You use the *api_key* and *api_secret* associated with primary and secondary accounts to connect to Nexmo API endpoints.

### Manage your profile

Dashboard uses the the information you gave during setup to create your Nexmo profile. This includes:

* Contact information - phone number, email, skype and password.
* Company information - name, address and VAT number.

To change your profile information:

1. [Sign in](https://dashboard.nexmo.com/sign-in) to Dashboard.
2. On the top-right of Dashboard, click the arrow next to **&lt;username>**, then click **Edit profile**.
3. Update your contact or company information, then click **Save changes**.

### Reset your password

To reset your Nexmo password:

1. Navigate to [Forgot your password?](https://dashboard.nexmo.com/sign-in/forgot-password target: _blank).
2. Enter the email address associated with your Nexmo account and click **Reset password**.
3. You receive a password reset link at the the email address associated with your Nexmo account. This link is valid for 15 minutes.
4. Navigate to the reset link and reset your password.

If having are still having issues, please contact <support@nexmo.com>.

## Manage payments

You top up your Nexmo account using Paypal, Visa, MasterCard or a Bank Transfer. For security reasons you associate a credit card or PayPal account with one Nexmo account only.

One-click payments are quick and easy transactions made with a credit card stored for your account. You are not required to re-enter your credit card details as these are stored with our Payment Service Provider (PSP), Braintree. Braintree (owned by PayPal) is PCI level 1 compliant. We do not store, manage or transmit any complete credit card information as part of our PCI Compliance certification. Nexmo has submitted and passed PCI DSS Self-Assessment Questionnaire Merchant Compliance. We can produce evidence of this upon request.

If we receive any credit card information from any of our customers in an email or helpdesk ticket, we immediately delete it and notify you that the information has been removed.

You use Dashboard to

* [Add a payment method](#add_payment_method)
* [Auto reload your account balance](#auto_reload )
* [Setup balance notifications](#notifications)
* [Delete a payment method](#delete_payment)
* [Change balance currency](#change_balance_currency)
* [Generate invoices](#invoices)

### Add a payment method

To add a payment method to your Nexmo account:

1. [Sign in](https://dashboard.nexmo.com/sign-in) to Dashboard.
1. On the top-right of Dashboard, click the arrow next to **&lt;username>**, then click **Billing & payments**.
2. Select an amount, click **Add a new payment method**, then click **Make payment**.
3. Choose a **Payment method**, fill in the **Billing method** and click **Next**.

  * PayPal - you are directed to the PayPal website to complete your payment.
  * Credit card - enter your card details. Your payment is processed in Dashboard.
  **Note**: You must provide the address associated with your credit card or PayPal account to successfully complete your payment.

The payment method is saved for future one-click payments. You can also set [auto reload](#auto_reload). If you do not see auto reload as an option in the Paypal payments page, ask support@nexmo.com to add the capability.

Payments appear as *Nexmo* on your bank statements.

### Auto reload your account balance

Using auto reload you configure the balance when Dashboard automatically adds funds to your Nexmo account from your payment method. You can also configure the payment method and amount added. By default, the amount added to your account is based on the transaction amount chosen when you [added a payment method](#add_payment_method).

When auto-reload is enabled your account balance is checked every 10 minutes. If you are sending a lot of messages, use [Developer API](tools/developer-api/account-top-up) to manage reloads when [remaining-balance](messaging/sms-api/api-reference#remaining-balance) in the response goes below a specific amount. Currently only PayPal auto-reload is available with the Developer API.

To setup auto reload on a payment method:

1. [Sign in](https://dashboard.nexmo.com/sign-in) to Dashboard.
2. On the top-right of Dashboard, click the arrow next to **&lt;username>**, then click **Billing & payments**.
3. Set Auto reload to *ON*.
4. Choose a payment method, the *Amount* to top up your account and the *Balance threshold* when your account is reloaded.
5. Click **Save**.

### Setup balance notifications

When the balance in your account reaches zero:

* You can no longer use our APIs.
* Your virtual numbers are cancelled.

To receive an email whenever your account balance is less than a specific sum:

1. [Sign in](https://dashboard.nexmo.com/sign-in) to Dashboard.
3. In the top-right of Dashboard, click the arrow next to **&lt;username>**, then click **Settings**.
3. Add your email to **Invoice & balance alerts**.
4. Enable **Balance alert** and set the **Balance threshold**.
4. Click **Save changes**.

Your account is automatically checked for a low balance every hour.

**Note**: you can use Developer API to [query your account balance](tools/developer-api/account-get-balance).

### Delete a payment method

To remove a credit card or payment method from your account:

1. Navigate to [Billing & Payments](https://dashboard.nexmo.com/billing-and-payments/billing-information) in Dashboard.
2. Select the payment method you want to remove.
3. Click the link next to the credit card or PayPal icon.
  You see the billing information for the payment method.
4. Click the delete link.

### Change balance currency

Nexmo's operating currency is the Euro. By default, your balance is displayed in Euros. However, you can also view your balance in USD.

To change the currency your balance is displayed in:

1. Navigate to [Settings](https://dashboard.nexmo.com/billing-and-payments/settings) in Dashboard.
2. Set *Display balance in* to your currencey of choice.

*Note*: this only changes the display in Dashboard you are always charged in Euro. Prices shown in USD fluctuate with the USD-EUR exchange rate.

### Generate invoices

Nexmo uses a third party provider to generate invoices. When you request an invoice our provider sends the invoice to either the  email address associated with your account or the finance email address defined in [Settings](https://dashboard.nexmo.com/billing-and-payments/settings). Invoices are printed by company name. If you use multiple Nexmo accounts you must set a different company name in each [account profile](https://dashboard.nexmo.com/edit-profile target:_blank).

You can generate an invoice from Dashboard once for each payment:

* Bank transfers - a pro-forma invoice is emailed to you when you create a new payment. The final invoice is generated upon receipt of payment. Banks take 1-3 working days to process payments.
* PayPal - the final invoice is automatically generated upon receipt of payment. You download this invoice from [Billing & Payments](https://dashboard.nexmo.com/billing-and-payments).
* Credit cards - take up to 72 hours to be generated while the payment is pending. During this period you cannot download the invoice from [Billing & Payments](https://dashboard.nexmo.com/billing-and-payments).

Use the *Download Transactions (.xls)* and *Account Activity (.xls)* links at the bottom of [Billing & Payments](https://dashboard.nexmo.com/billing-and-payments) to see all account activity.


## Manage numbers

You use a Nexmo virtual number to reception inbound communication from your users.

You rent each virtual number by the month. The renewal date is relative to the original subscription date. The rental price is automatically deducted from your Nexmo account on the same day every month. However, if you rented a virtual number on the last day of the month, the renewal date is last day of the next month. For example: 28.02.2015, 31.03.2015, 30.04.2015.

You use Dashboard to:

* [Rent virtual numbers](#rent-vn)
* [Setup Two-factor authentication](#shortcode)
* [Setup event based alerts](#event_based_alerts)

### Rent virtual numbers

To rent a Nexmo virtual number:

1. [Sign in](https://dashboard.nexmo.com/sign-in) to Dashboard.
2. Click **Numbers**, then **Buy Numbers**.
3. Select the attributes you need and click **Search**.
4. Click the number you want and validate your purchase.
5. Your virtual number is now listed in **Your numbers**.

If your account has no credit your virtual numbers are released for resale. To avoid this, enable [auto-reload payments](#add_payment_method).

**Note**: to rent virtual numbers programmatically, call [Number: Search](tools/developer-api/number-search) to list the available numbers, then [Number: Buy](tools/developer-api/number-buy) to rent one of the numbers returned by the search.

### Configure a virtual number

To configure a Nexmo virtual number:

1. [Sign in](https://dashboard.nexmo.com/sign-in) to Dashboard.
2. Click **Numbers**.
3. Select the virtual number to configure and click **Edit**.
4. Update your configuration, then click **Update**.
  If you are changing a webhook endpoint, ensure that your webhook endpoint is live before you press Update.
5. Your virtual number is now listed in **Your numbers**.

### Setting up Two-factor authentication

To use [Two-factor Authentication API](messaging/us-short-codes-api/two-factor-authentication):

1. [Sign in](https://dashboard.nexmo.com/sign-in) to Dashboard.
2. Click **Numbers**, then **Buy Numbers**.
3. Click **add a shared short code**.
3. Click **Add a short code for two factor authentication**.
4. Configure your message, then click **Update**.

When you use a Pre-approved US Short Code you **MUST** show the following information at the opt-in website for your service:

* Frequency - how many messages per day.
* How to opt-out - Send 'STOP' SMS to Short Code xxxxx.
* How to get help - Send 'HELP' SMS to Short Code xxxxx.
* The message and data rate that may apply.
* A link to the:
  * Terms and Conditions.
  * Privacy Policy.

For example:

```
You will receive no more than 2 msgs/day. To opt-out at any time, send STOP to 98975. To receive more information, send HELP to 98975. Message and Data Rates May Apply. The terms and conditions can be viewed at <http://url.to/your_t&c.html>. Our Privacy Policy can be reviewed at <http://url.to/your_privacypolicy.html>.
```

###Setting up event based alerts

To send [Event Based Alerts](messaging/us-short-codes-api/event-based-alerts) to your users:

1. [Sign in](https://dashboard.nexmo.com/sign-in) to Dashboard.
2. Click **Numbers**, then **Buy Numbers**.
3. Click **add a shared short code**.
3. Click **Add a shortcode for alerting**.
4. Configure your alert, then click **Update**.

##Supported browsers

The following browsers are supported by Dashboard:

* Chrome Stable
* Firefox Stable
* OS X Safari 8
* OS X Safari 9
* iOS 9 Safari
* iOS Chrome Stable
* Internet Explorer 10
* Internet Explorer 11
* Android Chrome Tablet*
* Android Other Mobile*
* Android Firefox Stable*
* iOS Safari Tablet View*

The following dimensions are supported:

* 1366x768
* 1920x1080
* 1280x1024
* 1024x768*

**Note**: you must have JavaScript enabled to view Dashboard correctly.
