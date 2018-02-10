require 'spec_helper'
require 'ostruct'

describe CommandLine do
  let(:cli) { LoadRunner::CommandLine }

  describe "without arguments" do
    it "shows usage patterns" do
      expect {cli.execute}.to output(/Usage:/).to_stdout
    end
  end

  describe "server" do
    let(:command) { %w[server] }

    it "starts the web server" do
      expect(Server).to receive(:run!)
      cli.execute command
    end
  end

  describe "send" do
    let(:command) { %w[send my_server my_repo push] }
    let(:response) { "Dummy response" }

    it "sends a request" do
      expect_any_instance_of(Client).to receive(:send_event).and_return(response)
      expect {cli.execute command}.to output(/#{response}/).to_stdout
    end
  end

  describe "status" do
    let(:command) { %w[status me/myrepo somesha success ] }
    let(:response) { OpenStruct.new code: 200 }

    it "prints the response to stdout" do
      expect_any_instance_of(GitHubAPI).to receive(:status).and_return(response)
      expect {cli.execute command}.to output(/"#<OpenStruct code=200>"/).to_stdout
    end
    
    it "shows response code in stderr" do
      expect_any_instance_of(GitHubAPI).to receive(:status).and_return(response)
      expect {cli.execute command}.to output(/Response Code: 200/).to_stderr
    end
  end


end