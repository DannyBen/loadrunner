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
  end
end
