Loadrunner - GitHub Webhook Server and Event Simulator
======================================================

[![Gem Version](https://badge.fury.io/rb/loadrunner.svg)](https://badge.fury.io/rb/loadrunner)
[![Build Status](https://travis-ci.com/DannyBen/loadrunner.svg?branch=master)](https://travis-ci.com/DannyBen/loadrunner)
[![Maintainability](https://api.codeclimate.com/v1/badges/f1aae46eaf6365ea2ec7/maintainability)](https://codeclimate.com/github/DannyBen/loadrunner/maintainability)

---

Loadrunner is a multi-purpose utility for working with GitHub webhooks and 
statuses.

It provides these features:

- A web server that responds to GitHub webhook events and can run any 
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

1. Download the [hooks](hooks) directory from this repository, as an
   example. This directory contains several hook examples.
2. Make sure that all files within that folder are executable.
3. Start the server (from the `hooks` **parent** directory):
   `loadrunner server`
4. In another terminal, send a sample webhook event:
   `loadrunner event localhost:3000 myrepo push master

The server should respond with a detailed JSON response, specifying what
hooks were executed (`executed_hooks`) and what hooks *could have
been* executed, if they were defined in the hooks folder
(`matching_hooks`).


For more options, see the [documentation][1] or run

```shell
$ loadrunner --help
```



Building Hooks
--------------------------------------------------

When running the server, it will look for hooks (executable scripts) in
the `./hooks` directory, using one of these format:

    hooks/global
    hooks/<repo name>/global
    hooks/<repo name>/<event type>
    hooks/<repo name>/<event type>@branch=<branch name>
    hooks/<repo name>/<event type>@tag=<tag name>
    hooks/<repo name>/<event type>@tag

For example:

    hooks/global
    hooks/myrepo/global
    hooks/myrepo/push
    hooks/myrepo/push@branch=master
    hooks/myrepo/push@tag=release
    hooks/myrepo/push@tag

When none of the hooks are found, Loadrunner will respond with a list of
hooks it was looking for, so you can use this response to figure out what
it needs.

The hooks can be written in any language, and should simply be executable.

### Environment Variables

These environment variables are available to your hooks:

- `LOADRUNNER_REPO`
- `LOADRUNNER_OWNER`
- `LOADRUNNER_EVENT`
- `LOADRUNNER_BRANCH`
- `LOADRUNNER_COMMIT`
- `LOADRUNNER_REF`
- `LOADRUNNER_TAG`



Using as a Rack or Sinatra mount
--------------------------------------------------

If you wish to mount the Loadrunner server under another Rack or Sinatra
application, use the `Loadrunner::Server` as the handler.


```ruby
# config.ru
require "loadrunner/server"

map "/github" do
  run Loadrunner::Server
end

run YourOwnApp
```



Sending Pull Request status from Ruby code
--------------------------------------------------

You may use the `Loadrunner::Status` class to update the status of a
GitHub pull request.

First, make sure that your GitHub API access token is set in the environment
variable `GITHUB_ACCESS_TOKEN`.

```ruby
require 'loadrunner/status'

response = Loadrunner::Status.update repo: 'user/repo', 
  sha: 'commit sha string', 
  state: :pending,  # :pending :success :failure :error
  context: "My Hooks Server",
  description: "Jobs have not started yet",
  url: "http://example.com"
```

Only `repo`, `sha` and `state` are required, the rest arguments are optional.



Running with Docker
--------------------------------------------------

You can run both the server and the client using Docker.

```shell
# Server
$ docker run -p3000:3000 dannyben/loadrunner server

# Client
$ docker run dannyben/loadrunner event http://webhook.server.com repo push
```

If you wish to connect the client to the server you are running through Docker, 
you can do something like this:

```shell
$ docker run --network host dannyben/loadrunner event http://localhost:3000 repo push
```

See also: The [docker-compose file](docker-compose.yml).

[1]: http://www.rubydoc.info/gems/loadrunner
