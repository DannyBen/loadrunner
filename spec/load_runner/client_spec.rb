require 'spec_helper'

describe Client do
  describe "#send" do
    context "without arguments" do
      let(:payload) { {:ref=>nil, :repository=>{:name=>nil}} }

      it "builds and sends a payload" do
        expect(subject).to receive(:send_payload).with(:push, payload)
        subject.send
      end
    end

    context "with arguments" do
      let(:payload) { {:ref=>'refs/heads/test', :repository=>{:name=>'myrepo'}} }

      it "builds and sends a payload" do
        expect(subject).to receive(:send_payload).with(:ping, payload)
        subject.send :ping, ref: 'refs/heads/test', repo: 'myrepo'
      end
    end
  end

  describe "#send_payload" do
    let(:payload) { {:ref=>'refs/heads/test', :repository=>{:name=>'myrepo'}} }
    
    it "sends a post http message to /payload" do
      expect(described_class).to receive(:post).with('/payload', any_args)
      subject.send_payload(:push, payload)
    end

    it "converts payload to json" do
      expected = { body: payload.to_json, headers: { "X_GITHUB_EVENT"=>"push" } }
      expect(described_class).to receive(:post).with(anything, expected)
      subject.send_payload(:push, payload)
    end
  end
end