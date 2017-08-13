require 'spec_helper'

describe Server do
  it "works" do
    get '/'
    expect(last_response).to be_ok
    expect(last_response.body).to eq "ok"
  end
end