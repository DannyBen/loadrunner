require 'spec_helper'

describe Server do
  it "works" do
    get '/'
    expect(last_response).to be_ok
    expect(last_response.body).to eq "OK"
  end

  describe "/payload" do
    let(:payload) { {key: 'value'}.to_json }

    it "executes the runner" do
      expect_any_instance_of(Runner).to receive(:execute)
      post '/payload', payload
    end

    context "when a signature is required" do
      before do
        ENV['GITHUB_SECRET_TOKEN'] = '123'
      end

      after do
        ENV['GITHUB_SECRET_TOKEN'] = nil
      end

      it "halts with 401" do
        expect_any_instance_of(Runner).not_to receive(:execute)
        post '/payload', payload
        expect(last_response.status).to be 401
        expect(last_response.body).to eq halt_messages[:no_client]
      end
    end
  end
end
