0.11.0 / 08-08-2017
==================

# Feature
  * Conversation collection updated for incoming contextual event i.e text and image
  * Expose a reason for new conversation insert i.e "invited by"
  * Exposed timestamp of member states
# Bugs
  * Fix crash on sync
  * Made sure date foramtter created ones 
  * Reduce excess consuming of memory by about 80%
  * Handle member already has joined error


0.10.0 / 21-07-2017
==================

# Feature
  * Conversation collection can now be observed 
# Bugs
  * Fix crash on sync
  * Event body savedwith the correct format 


0.9.3 / 06-07-2017
==================

# Breaking change
  * accountController renamed to account
  * conversationController renamed to conversation
  * client.close() renamed to client.disconnect() 
# Feature
 * Kick member from own object
# Bugs
  * Fixed issue where sync could not be completed


0.9.2 / 30-06-2017
==================

# Bugs
  * Remove join checks when making network request


0.9.1 / 26-06-2017
==================

# Feature  
  * Equatable for public enum
  * Update event that are deleted and insert new type, timestamp and payload
# Bugs
  * Connects twice on first run
  

0.9.0 / 16-06-2017
==================

# Breaking change
  * Create conversation returns a facade object rather then the REST model
  * Removed Objective-C prefix NXM and NX for Swift
# Feature
  * Custom log level. use `Configuration.default`
  * Internal error reporting. use `Client.internalNetworkError`
# Bugs
  * Fix issue where display name was not set
  * Fix issue with creating new conversation with same name failed


0.8.0 / 31-05-2017
==================

# Breaking changes
  * Deprecated
    `client.connectionStatusChanged`
    `client.syncComplete`
  * New
    `client.state`
    ```
      /// Global state of client
      ///
      /// - disconnected: Default state SDK has disconnected from all services. triggered on user logout/disconnects and inital state
      /// - connecting: Requesting permission to reconnect
      /// - connected: Connected to all services
      /// - outOfSync: SDK is not in sync yet
      /// - synchronizing: Synchronising with current progress state
      /// - synchronized: synchronised all services and ready to be used
      enum State {
      case disconnected
      case connecting
      case connected
      case outOfSync
      case synchronizing(SynchronizingState)
      case synchronized
      }

      /// State of synchronizing
      ///
      /// - conversations: processing conversations
      /// - events: processing events
      /// - members: processing members
      /// - users: processing users
      /// - receipt: processing receipts
      /// - tasks: sending all unsent request i.e events
      enum SynchronizingState {
      case conversations
      case events
      case members
      case users
      case receipt
      case tasks
      }
    ```
# Changes
  * Client console log configurable uisng `Configuration` class. i.e 
  ```
   client.configuration = Configuration(with: .info)
   client.login(with: TOKEN)
  ```


0.7.0 / 26-04-2017
==================

# Changes
  * Remove seenDate and deliveredDate from receipt records. Only keep NXMReceiptRecord.date as we know the type already
  * Change User.me to: accountController.user 
  * Send event is now done in one step i.e send(String), send(Image)
  * Same conversation object is not passed back in callbacks
  * 'setTrying(:Bool)' is now two methods called start and stop
  * Exposed last event id in conversation
  * Renamed some classses to only use prefix in Objective-c
  * Updated dependencies
  * Updated docs
# Bugs 
  * Bug fixes

0.6.1 / 11-04-2017
==================

# Feature
  * better access of user state
  * Delete events
# Bugs
  * Bug fixes
# Changes
  * Stabilised SDK
  * Updated dependencies
  * Updated docs
  * Support for Carthage
  * New framework on Git tag

0.0.6 / 24-03-2017
==================

# Bugs 
  * Bug fixes
# Changes
  * Expose conversation and Event method
  * Stabilised SDK
  * Updated dependencies

0.0.5 / 08-11-2016
==================

# Bugs 
  * Bug fixes
  * Base URL not points to prod

0.0.4 / 04-10-2016
==================

# Feature
  * Send image
  * IPS
  * Push notification support

0.0.3 / 07-10-2016
==================

# Bugs 
  * Bug fixes
# Changes
  * Minor framework update

0.0.1 / 04-10-2016
==================

# Changes
  * Initial commit
