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

    it "starts the web server"
  end

  describe "send" do
    let(:command) { %w[send] }

    it "sends a request"
  end

end