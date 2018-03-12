# A repo host the API SDK documentation for JS, Android, and iOS

The docs are hosted on ea.developer.nexmo.com

# Making changes

- After updating the docs in this repo, navigate to your local copy of `nexmo-developer-private`
- Run the rake task `$ rake repos:pull nexmo/conversation-docs`
- Make a PR with your changes to the `nexmo-developer-private` repo
- Merge the PR and deploy a new version of the `nexmo-developer-private` site
