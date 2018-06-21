LoadRunner - GitHub Webhook Server and Event Simulator
======================================================

[![Gem Version](https://badge.fury.io/rb/loadrunner.svg)](https://badge.fury.io/rb/loadrunner)
[![Build Status](https://travis-ci.com/DannyBen/loadrunner.svg?branch=master)](https://travis-ci.com/DannyBen/loadrunner)
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

```shell
# Create a sample hook handler
$ mkdir -p handlers/myrepo
$ echo '#!/usr/bin/env bash' > handlers/myrepo/push
$ echo 'echo hello > output.txt' >> handlers/myrepo/push
$ chmod +x handlers/myrepo/push

# Start the server
$ loadrunner server

# In another terminal, send a sample webhook event
$ loadrunner event localhost:3000 myrepo push master

# Verify the handler was executed
$ cat output.txt
```


For more options, see the [documentation][1] or run

```shell
$ loadrunner --help
```



Building Handlers
--------------------------------------------------

When running the server, it will look for handlers in the `./handlers` 
directory, using one of these format:

    handlers/<repo name>/<event type>
    handlers/<repo name>/<event type>@branch=<branch name>
    handlers/<repo name>/<event type>@tag=<branch name>

For example:

    handlers/myrepo/push
    handlers/myrepo/push@branch=master
    handlers/myrepo/push@tag=release

When none of the handlers are found, LoadRunner will respond with a list of
handlers it was looking for, so you can use this response to figure out what
it needs.

The handlers can be written in any language, and should simply be 
executables.

### Environment Variables

These environment variables are available to your handlers:

- `REPO`
- `EVENT`
- `BRANCH`
- `REF`
- `TAG`
- `PAYLOAD` - the entire JSON string as received from GitHub, or the client.



Running with Docker
--------------------------------------------------

You can run both the server and the client using Docker.

    # Server
    $ docker run -p3000:3000 dannyben/loadrunner server

    # Client
    $ docker run dannyben/loadrunner event http://webhook.server.com/payload repo push

If you wish to connect the client to the server you are running through Docker, 
you can do something like this:

    $ docker run --network host dannyben/loadrunner event http://localhost:3000/payload repo push

See also: The [docker-compose file](docker-compose.yml).

[1]: http://www.rubydoc.info/gems/loadrunner
