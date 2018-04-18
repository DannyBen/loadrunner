LoadRunner - GitHub Webhook Server and Event Simulator
======================================================

[![Gem Version](https://badge.fury.io/rb/loadrunner.svg)](https://badge.fury.io/rb/loadrunner)
[![Build Status](https://travis-ci.org/DannyBen/loadrunner.svg?branch=master)](https://travis-ci.org/DannyBen/loadrunner)
[![Maintainability](https://api.codeclimate.com/v1/badges/f1aae46eaf6365ea2ec7/maintainability)](https://codeclimate.com/github/DannyBen/loadrunner/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/f1aae46eaf6365ea2ec7/test_coverage)](https://codeclimate.com/github/DannyBen/loadrunner/test_coverage)

---

LoadRunner is a multi-purpose utility for working with GitHub webhooks and 
statuses.

It provides these features:

- A webserver that responds to GitHub webhook events and can run any 
  arbitrary script written in any language.
- A command line utility for testing your webhook server configuration by
  sending simulated events.
- A command line utility for sending status updates to pull requests.

---

Install
--------------------------------------------------

```
$ gem install loadrunner
```

Getting Started
--------------------------------------------------

    # Create a sample hook handler
    $ mkdir -p handlers/myrepo
    $ echo "#\!/usr/bin/env bash" > handlers/myrepo/push
    $ echo "echo hello > output.txt" >> handlers/myrepo/push
    $ chmod +x handlers/myrepo/push

    # Start the server
    $ loadrunner server

    # In another terminal, send a sample webhook event
    $ loadrunner send localhost:3000 myrepo push master

    # Verify the handler was executed
    $ cat output.txt


For more options, see the [documentation][1] or run

    $ loadrunner --help


[1]: http://www.rubydoc.info/gems/loadrunner