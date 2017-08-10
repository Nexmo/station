# Nexmo Conversation SDK

[![BuddyBuild](https://dashboard.buddybuild.com/api/statusImage?appID=5824a77e7424bc0100c4defb&branch=master&build=latest)](https://dashboard.buddybuild.com/apps/5824a77e7424bc0100c4defb/build/latest) 
[![CocoaPods](https://img.shields.io/cocoapods/v/NexmoConversation.svg)]() (in private beta) 
[![CocoaPods](https://img.shields.io/cocoapods/l/NexmoConversation.svg)]() 
[![CocoaPods](https://img.shields.io/cocoapods/p/NexmoConversation.svg)]() 
[![Swift](https://img.shields.io/badge/Swift-3.1.X-orange.svg)]()
[![Carthage compatible](https://img.shields.io/badge/Carthage-soon-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) 
[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-soon-brightgreen.svg)](https://github.com/apple/swift-package-manager)
[![codecov](https://codecov.io/gh/Nexmo/conversation-ios-sdk/branch/master/graph/badge.svg)](https://codecov.io/gh/Nexmo/conversation-ios-sdk)
[![Twitter](https://img.shields.io/badge/twitter-@Nexmo-blue.svg?style=flat)](https://twitter.com/Nexmo)

The Conversation SDK is intended to provide a ready solution for developers who want to integrate chat, voice and video into their apps.

# Installation
### [CocoaPods](http://cocoapods.org)
A dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

Integrate NexmoConversation into your project using CocoaPods, specify SDK in your `Podfile`:

```ruby
source 'git@github.com:Nexmo/PodSpec.git'
source 'git@github.com:CocoaPods/Specs.git'

target '<Your Target Name>' do
    pod 'NexmoConversation' # Stable version
    pod 'NexmoConversation', :git => "git@github.com:nexmoinc/conversation-ios-sdk.git", branch => "master" # Development version
end
```

Then, run the following command:

```bash
$ pod install
```

### [Carthage](https://github.com/Carthage/Carthage)

Add this to `Cartfile`

```
github "Nexmoinc/NexmoConversation" ~> 0.10
```

```bash
$ carthage update
```

# SDK Setup
In the Project Navigator, click on "Info.plist" for your target.

- Add new row and set row type as a dictionary with the name `Nexmo`
- Add new row inside `Nexmo` dictionary called `ConversationApplicationID` and set it as string type
- Add your application Id taking from the CLI interface

## Prerequisite for testing in development environment

Configure the environment do the following commands:

```
$ gem install bundler
```
```
$ bundle install && pod update
```
```
$ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```
```
$ brew bundle
```

To use project with development endpoints:

- Go to target schemes selection box and click on manage schemes
- Duplicate ConversationDemo (Please make sure shared is deselected)
- Under Run tab add the following environment variable endpoints for `socket_url`, `ips_url`, `rest_url` and `acme_url`.

# Deploy
[Fastlane](https://github.com/fastlane/fastlane): Automate beta deployments and releases for our iOS demo apps. 🚀 It handles all tedious tasks, like generating screenshots, dealing with code signing, and releasing your application.

```
$ fastlane test
```
Runs all the tests

```
$ fastlane code_coverage
```
Display test code coverage

```
$ fastlane beta
```
Submit a new Beta Build to Apple TestFlight

```
$ fastlane doc
```
Update SDK docs

```
$ fastlane ios deploy
```
Package SDK to a framework

# Testing 
All test code are written in Swift, Network request should never reach network always use JSON stubs file to intercept request. We use third party tools for testing the framework over Apple XCTest: 
- [Nimble](https://github.com/Quick/Nimble): Express the expected outcomes of Swift or Objective-C expressions with a BDD-styled approach
- [Quick](https://github.com/Quick/Quick): Behavior-driven development framework for Swift and Objective-C. Inspired by RSpec, Specta, and Ginkgo.
- [MockingJay](https://github.com/kylef/Mockingjay): Stubbing HTTP requests with ease in Swift

## E2E and Hermetic test
These type of class are designed to be gray-boxed. In each target, you can customise base URL by adding `socket_url`, `rest_url`, `acme_url` and `ips_url`. 

# Code style & Conventions 
- https://github.com/schwa/Swift-Community-Best-Practices
- https://github.com/github/swift-style-guide

# License
Copyright (c) 2016 Nexmo, Inc. All rights reserved. Licensed only under the Nexmo Conversation SDK License Agreement (the "License") located at

By downloading or otherwise using our software or services, you acknowledge that you have read, understand and agree to be bound by the Nexmo Conversation SDK License Agreement and Privacy Policy.

You may not use, exercise any rights with respect to or exploit this SDK, or any modifications or derivative works thereof, except in accordance with the License.

# Author
* Jodi Humphreys, jodi.humphreys@vonage.com  
* Shams Ahmed, shams.ahmed@vonage.com  
* Ivan Ivanov, ivan.ivanov@vonage.com  
* James Green, james.green@green-custard.com  
* Paul Calver, paul.calver@vonage.com  

