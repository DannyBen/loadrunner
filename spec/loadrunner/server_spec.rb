require 'spec_helper'

describe Server do
  let(:runner_double) { double Runner, execute: true }

  it 'is successful' do
    get '/'
    expect(last_response).to be_ok
    expect(last_response.body).to eq 'loadrunner ready'
  end

  describe 'POST /' do
    let(:payload) { { key: 'value' }.to_json }

    context 'with a json request' do
      let(:header) { { 'CONTENT_TYPE' => 'application/json' } }

      it 'executes the runner' do
        allow(Runner).to receive(:new).and_return runner_double
        expect(runner_double).to receive(:execute)
        post '/', payload, header
      end
    end

    context 'with a form-urlencoded request' do
      let(:header) { { 'CONTENT_TYPE' => 'application/x-www-form-urlencoded' } }
      let(:payload) { URI.encode_www_form({ payload: { key: 'value' }.to_json }) }

      it 'executes the runner' do
        allow(Runner).to receive(:new).and_return runner_double
        expect(runner_double).to receive(:execute)
        post '/', payload, header
      end
    end

    context 'when a signature is required' do
      before { ENV['GITHUB_SECRET_TOKEN'] = '123' }
      after { ENV['GITHUB_SECRET_TOKEN'] = nil }

      it 'halts with 401' do
        allow(Runner).to receive(:new).and_return runner_double
        expect(runner_double).not_to receive(:execute)

        post '/', payload

        expect(last_response.status).to be 401
        expect(last_response.body).to eq halt_messages[:no_client]
      end
    end
  end
end
