require 'spec_helper'

describe CommandLine do
  let(:cli) { LoadRunner::CommandLine.clone.instance }

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
      expect_any_instance_of(Client).to receive(:send).and_return(response)
      expect {cli.execute command}.to output(/#{response}/).to_stdout
    end
  end

end