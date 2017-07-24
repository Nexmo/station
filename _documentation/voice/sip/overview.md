---
title: Overview
description: Use Nexmo SIP to forward inbound and send outbound Voice calls that use the Session Initiation Protocol.
---

# SIP Overview

You use Nexmo SIP to [forward inbound](#forward-inbound) and [send outbound](#sip-outbound) Voice calls that use the [Session Initiation Protocol](https://en.wikipedia.org/wiki/Session_Initiation_Protocol).

The following table explains the different configuration options:


**Endpoint**

You send your [INVITE](https://en.wikipedia.org/wiki/List_of_SIP_request_methods) requests to the Nexmo SIP endpoint: `sip.nexmo.com`.

**Authentication**

Every INVITE request is authenticated with Digest authentication:

- `username` - your Nexmo *key*
- `password` - your Nexmo *secret*

**Service records**

If your system is not enabled for [Service records](https://en.wikipedia.org/wiki/SRV_record) (SRV record), load balance between the two closest endpoints and set the remaining ones as backup. The Nexmo SIP endpoints are:

- `sip-us1.nexmo.com` (Washington)
- `sip-us2.nexmo.com` (Washington)
- `sip-eu1.nexmo.com` (London)
- `sip-eu2.nexmo.com` (London)
- `sip-ap1.nexmo.com` (Singapore)
- `sip-ap2.nexmo.com` (Singapore)

**Recipient**

You configure the recipient number in [E.164](https://en.wikipedia.org/wiki/E.164). That is: `country code+area code+local code+extension`. For example, the phone number 331908817135 is made up of: CC = 33, AC = 1908, LC = 8, Ext = 17135.

**Caller Id**

Set the Caller Line Identity (CLI) in the *From* header using E.164. For example: `From: <sip:447937947990@sip.nexmo.com>`.

**Codecs**

The following codecs are supported:

- PCMA (G711a)
- PCMU (G711u)
- iLBC
- g729 (without annexb)
- g722
- Speex16

**Media traffic**

The list of IPs/subnets is subject to change. Rather than white-listing specific subnets, open traffic from all IP ranges to port range `10000:20000`.

**DTMF**

Nexmo supports out-of-band. For more information, see [RFC2833](https://www.ietf.org/rfc/rfc2833.txt).

**Health checks**

Use the OOD [OPTIONS](https://en.wikipedia.org/wiki/List_of_SIP_request_methods) method to run a health check on our SIP trunks.

**Protocols**

You can use the following protocols:

- UDP on port 5060
- TCP on port 5060
- TLS on port 5061

Transport Layer Security (TLS) is a cryptographic protocol designed to provide communications security to your SIP connection. You can use self-signed certificates on your user agent, Nexmo does not validate the certificate on the client side. <br>Connections using TLS 1.0 or more recent are accepted. Older protocols are disabled as they are considered insecure.

## Inbound configuration

This section tells you how to:

- [Configure your system for SIP forwarding](#configure-your-system-for-sip-forwarding)
- [Configure example servers](#configure-example-servers)

## Configuring your system for SIP forwarding

To configure for SIP forwarding:

1. Sign into [Dashboard](https://dashboard.nexmo.com/sign-in).
2. In Dashboard, click *Products* > *Numbers*.
3. Scroll to the number to forward from, then select *Forward to SIP*.
4. Type a valid SIP URI and click *Update*. For example 1234567890@mydomain.com.
  This field supports comma-separated entries for failover capabilities. For example: `1234567890@mydomain.com, 1234567890@my2domain.com, 1234567890@my3domain.com`. If you set more than one endpoint in *Forward to SIP* the call is initially forwarded to the first endpoint in the list. If this fails, the call is forwarded to the second endpoint in the list, and so on.
  Calls failover for the whole 5xx class of HTTP errors. The timeout is 486.
5. Ensure that the traffic generated from the following IP addresses can pass your firewall:

  * 173.193.199.24
  * 174.37.245.34
  * 5.10.112.121
  * 5.10.112.122
  * 119.81.44.6
  * 119.81.44.7

> **Note**: Nexmo supports TLS on inbound connections. To enable this, enter a valid secure URI in the format sips:user@(IP|domain). For example, *sips:1234567890@mydomain.com*. By default, traffic is sent to port 5061. To use a different port, add it at the end of your URI: *sips:1234567890@mydomain.com:5062*.

## Example configurations

The following table gives example configurations for forwarding inbound calls:

### `http://www.asterisk.org`

````
[nexmo-sip]
fromdomain=sip.nexmo.com
type=peer
context=nexmo
insecure=port,invite
nat=no
;Add your codec list here.
; Note: Use "ulaw" for US only, "alaw" for the rest of the world.
allow=ulaw
allow=alaw
allow=G729
dtmfmode=rfc2833

[nexmo-sip-01](nexmo-sip)
host=173.193.199.24

[nexmo-sip-02](nexmo-sip)
host=174.37.245.34

[nexmo-sip-03](nexmo-sip)
host=5.10.112.121

[nexmo-sip-04](nexmo-sip)
host=5.10.112.122

[nexmo-sip-05](nexmo-sip)
host=119.81.44.6

[nexmo-sip-06](nexmo-sip)
host=119.81.44.7
````

### `http://www.freepbx.org`

````
host=173.193.199.24
type=friend
insecure=port,invite
;Add your codec list here.
; Note: Use "ulaw" for US only, "alaw" for the rest of the world.
allow=ulaw,alaw,g729
dtmfmode=rfc2833

host=174.37.245.34
type=friend
insecure=port,invite
;Add your codec list here.
; Note: Use "ulaw" for US only, "alaw" for the rest of the world.
allow=ulaw,alaw,g729
dtmfmode=rfc2833

host=5.10.112.121
type=friend
insecure=port,invite
;Add your codec list here.
; Note: Use "ulaw" for US only, "alaw" for the rest of the world.
allow=ulaw,alaw,g729
dtmfmode=rfc2833

host=5.10.112.122
type=friend
insecure=port,invite
;Add your codec list here.
; Note: Use "ulaw" for US only, "alaw" for the rest of the world.
allow=ulaw,alaw,g729
dtmfmode=rfc2833

host=119.81.44.6
type=friend
insecure=port,invite
;Add your codec list here.
; Note: Use "ulaw" for US only, "alaw" for the rest of the world.
allow=ulaw,alaw,g729
dtmfmode=rfc2833

host=119.81.44.7
type=friend
insecure=port,invite
;Add your codec list here.
; Note: Use "ulaw" for US only, "alaw" for the rest of the world.
allow=ulaw,alaw,g729
dtmfmode=rfc2833
````

### `http://www.freeswitch.org`

To configure freeswitch you need to:

Modify `autoload_configs/acl.conf.xml` and allow traffic from Nexmo's IPs:

```xml
<list name="nexmo" default="deny">
  <node type="allow" cidr="173.193.199.24/32"/>
  <node type="allow" cidr="174.37.245.34/32"/>
  <node type="allow" cidr="5.10.112.121/32"/>
  <node type="allow" cidr="5.10.112.122/32"/>
  <node type="allow" cidr="119.81.44.6/32"/>
  <node type="allow" cidr="119.81.44.7/32"/>
</list>
```

Add the following to `sip_profiles/internal.xml`:

Create a public dial plan for Nexmo in `dialplan/public/nexmo_sip.xml`:

```xml
    <include>
      <extension name="nexmo_sip">
        <condition field="destination_number" expression="^(\d+)$">
          <action application="set" data="domain_name=$${domain}"/>
          <action application="transfer" data="1000 XML default"/>
        </condition>
      </extension>
    </include>
```

If you want to match a specific number from request URI, modify the expression:

````
(\d+)
````

> *Note*: this forwards incoming calls to registered extension 1000

## Outbound configuration

The following table gives example configurations for communicating with the Nexmo SIP endpoint for outbound calls:

### `http://www.asterisk.org`

````
[general]
    register => <key>:<secret>@sip.nexmo.com
[nexmo]
  username=<key>
  host=sip.nexmo.com
  defaultuser=<key>
  fromuser=<long_virtual_number>
  fromdomain=sip.nexmo.com
  secret=<secret>
  type=peer
  context=nexmo
  insecure=very
  qualify=yes
  nat=no
  ;Add your codec list here.
  ; Note: Use "ulaw" for US only, "alaw" for the rest of the world.
  allow=ulaw
  allow=alaw
  allow=G729
  dtmfmode=rfc2833
````

### `Asterisk 12+ with chan_pjsip`

````
; Basic UDP only endpoint.
[transport-udp]
  type=transport
  protocol=udp
  bind=0.0.0.0
[nexmo]
  type = endpoint
  aors = nexmo
  outbound_auth = nexmo-auth
  context = inbound
  transport=transport-udp
  from_user = <long_virtual_number> ; This is optional. CLI can be set in the dialplan
  allow=alaw
  allow=ulaw
  allow=g729
[nexmo]
  type = aor
  contact = sip:sip.nexmo.com
  qualify_frequency = 120
[nexmo-auth]
  type = auth
  auth_type = userpass
  username = <key>
  password = <secret>
[nexmo-reg]
  type = registration
  outbound_auth = nexmo-auth
  server_uri = sip:sip.nexmo.com
  client_uri = sip:<key>@sip.nexmo.com
[nexmo-identify]
  type = identify
  endpoint = nexmo
  match = 5.10.112.122
  match = 5.10.112.121
  match = 173.193.199.24
  match = 174.37.245.34
  match = 119.81.44.6
  match = 119.81.44.7
````

### `http://www.freepbx.org`

````
host=sip.nexmo.com
  type=friend
  insecure=port,invite
  qualify=yes
  ;Add your codec list here.
  ;Note: Use "ulaw" for US only, "alaw" for the rest of the world.
  allow=ulaw,alaw,g729
  dtmfmode=rfc2833

  username=<key>
  fromuser=<long_virtual_number>
  secret=<secret>

  Register String
  <key>:<secret>@sip.nexmo.com
````

### `http://www.freeswitch.org`

To configure freeswitch you need to:

Create an external profile:

```xml
<include>
   <gateway name="nexmo">
     <param name="proxy" value="sip.nexmo.com"/>
     <param name="register" value="true"/>
     <param name="caller-id-in-from" value="false"/>
     <param name="from-user" value="<long_virtual_number>"/>
     <param name="username" value="<key>"/>
     <param name="password" value="<secret>"/>
   </gateway>
  </include>
```

Make a dial plan:

```xml
<include>
  <extension name="international.mycompany.com">
    <condition field="destination_number" expression="^(00\d+)$">
      <action application="set" data="effective_caller_id_number=${outbound_caller_id_number}"/>
      <action application="set" data="effective_caller_id_name=${outbound_caller_id_name}"/>
      <action application="bridge" data="{origination_caller_id_name=<CALLER_ID>}sofia/gateway/nexmo/$1"/>
    </condition>
  </extension>
</include>
```
