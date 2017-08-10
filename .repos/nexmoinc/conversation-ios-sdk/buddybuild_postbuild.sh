#!/usr/bin/env bash

bash <(curl -s https://codecov.io/bash)

# Install swiftlint if necessary
if ! which swiftlint >/dev/null; then
brew install swiftlint
fi
