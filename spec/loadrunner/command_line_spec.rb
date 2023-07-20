require 'ostruct'

describe CommandLine do
  let(:cli) { Loadrunner::CommandLine }

  describe 'without arguments' do
    it 'shows usage patterns' do
      expect { cli.execute }.to output(/Usage:/).to_stdout
    end
  end

  describe 'server' do
    let(:command) { %w[server] }

    it 'starts the web server' do
      expect(Server).to receive(:run!)
      cli.execute command
    end
  end

  describe 'event' do
    let(:command) { %w[event my_server my_repo push] }
    let(:response) { 'Dummy response' }
    let(:client_double) { Client.new }

    it 'sends a request' do
      allow(Client).to receive(:new).and_return client_double
      allow(client_double).to receive(:send_event).and_return(response)

      expect { cli.execute command }.to output(/#{response}/).to_stdout
    end
  end

  describe 'payload' do
    let(:file) { 'spec/fixtures/payload.json' }
    let(:command) { %W[payload my_server push #{file}] }
    let(:response) { 'Dummy response' }
    let(:json) { File.read file }
    let(:client_double) { Client.new }

    it 'sends a request' do
      allow(Client).to receive(:new).and_return client_double
      allow(client_double).to receive(:send_payload).with('push', json).and_return(response)

      expect { cli.execute command }.to output(/#{response}/).to_stdout
    end

    context 'with an invalid file' do
      let(:file) { 'no-such-file.json' }

      it 'raises ArgumentError' do
        expect { cli.execute command }.to raise_error(ArgumentError)
      end
    end
  end

  describe 'status' do
    let(:command) { %w[status me/myrepo somesha success] }
    let(:response) { OpenStruct.new code: 200 }
    let(:github_api_double) { double GithubAPI, status: response }

    it 'prints the response to stdout' do
      allow(GithubAPI).to receive(:new).and_return github_api_double
      allow(github_api_double).to receive(:status).and_return(response)

      expect { cli.execute command }.to output(/#<OpenStruct code=200>.*Response Code: 200/m).to_stdout
    end
  end
end
