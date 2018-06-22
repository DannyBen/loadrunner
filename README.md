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

1. Download the [handlers](handlers) directory from this repository, as an
   exmaple. This directory contains several handler examples.
2. Make sure that all files within that folder are executables.
3. Start the server (from the `handlers` **parent** directory):
   `loadrunner server`
4. In another terminal, send a sample webhook event:
   `loadrunner event localhost:3000/payload myrepo push master

The server should respond with a detailed JSON response, specifying what
handlers were executed (`executed_handlers`) and what handlers *could have
been* executed, if they were defined in the handlers folder
(`matching_handlers`).
```


For more options, see the [documentation][1] or run

```shell
$ loadrunner --help
```



Building Handlers
--------------------------------------------------

When running the server, it will look for handlers (executable scripts) in
the `./handlers` directory, using one of these format:

    handlers/global
    handlers/<repo name>/global
    handlers/<repo name>/<event type>
    handlers/<repo name>/<event type>@branch=<branch name>
    handlers/<repo name>/<event type>@tag=<branch name>

For example:

    handlers/global
    handlers/myrepo/global
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

- `LOADRUNNER_REPO`
- `LOADRUNNER_EVENT`
- `LOADRUNNER_BRANCH`
- `LOADRUNNER_REF`
- `LOADRUNNER_TAG`
- `LOADRUNNER_PAYLOAD` - the entire JSON string as received from GitHub, or the client.



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
