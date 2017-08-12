require 'loadrunner'
require 'byebug'

payload = {
  ref: "refs/tags/0.0.1",
  # ref: "refs/heads/master",
  base_ref: "refs/heads/master",
  repository: {
    name: "experiments",
    full_name: "DannyBen/experiments"
  }
}

client = LoadRunner::Client.new base_url: 'localhost:3000', secret_token: '123'
# puts client.send_payload payload
result = client.send :push, repo: 'danny/example', branch: 'master'
puts result


