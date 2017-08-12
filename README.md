LoadRunner - GitHub Webhook Server and Event Simulator
======================================================

[![Gem](https://img.shields.io/gem/v/loadrunner.svg?style=flat-square)](https://rubygems.org/gems/loadrunner)
[![Travis](https://img.shields.io/travis/DannyBen/loadrunner.svg?style=flat-square)](https://travis-ci.org/DannyBen/loadrunner)
[![Code Climate](https://img.shields.io/codeclimate/github/DannyBen/loadrunner.svg?style=flat-square)](https://codeclimate.com/github/DannyBen/loadrunner)
[![Gemnasium](https://img.shields.io/gemnasium/DannyBen/loadrunner.svg?style=flat-square)](https://gemnasium.com/DannyBen/loadrunner)

---

LoadRunner is a dual-purpose utility for working with GitHub webhooks.

It provides these features:

- A webserver that responds to GitHub webhook events and can run any 
  arbitrary script writtn in any language.
- A command line utility for testing your webhook server configuration.

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

    # Start the server
    $ loadrunner server

    # In another terminal, send a sample webhook event
    $ loadrunner send localhost:3000 myrepo push master

    # Verify the handler was executed
    $ cat output.txt


