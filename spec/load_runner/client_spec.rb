require 'spec_helper'

describe Client do
  describe "#send_event" do
    context "without arguments" do
      let(:payload) { {:ref=>nil, :repository=>{:name=>nil}} }

      it "builds and sends a payload" do
        expect(subject).to receive(:send_payload).with(:push, payload)
        subject.send_event
      end
    end

    context "with arguments" do
      let(:payload) { {:ref=>'refs/heads/test', :repository=>{:name=>'myrepo'}} }

      it "builds and sends a payload" do
        expect(subject).to receive(:send_payload).with(:ping, payload)
        subject.send_event :ping, ref: 'refs/heads/test', repo: 'myrepo'
      end
    end

    context "with branch argument" do
      it "converts it to ref" do
        expected = { ref: "refs/heads/branchy" }
        expect(subject).to receive(:send_payload).with(anything, hash_including(expected))
        subject.send_event :push, branch: 'branchy'
      end
    end

    context "with tag argument" do
      it "converts it to ref" do
        expected = { ref: "refs/tags/tagly" }
        expect(subject).to receive(:send_payload).with(anything, hash_including(expected))
        subject.send_event :push, tag: 'tagly'
      end
    end

    context "with a full name repo" do
      it "extracts its short name" do
        expected = { repository: { name: "myrepo", full_name: 'me/myrepo' } }
        expect(subject).to receive(:send_payload).with(anything, hash_including(expected))
        subject.send_event :push, repo: 'me/myrepo'
      end
    end
  end

  describe "#send_payload" do
    let(:payload) { {ref: 'refs/heads/test', repository: {name: 'myrepo'}} }
    
    it "sends a post http message to /payload" do
      expect(described_class).to receive(:post).with('/payload', any_args)
      subject.send_payload(:push, payload)
    end

    it "converts payload to json" do
      expected = { body: payload.to_json, headers: { "X_GITHUB_EVENT"=>"push" } }
      expect(described_class).to receive(:post).with(anything, expected)
      subject.send_payload(:push, payload)
    end

    context "when secret_token is set" do
      before do
        subject.secret_token = '123'
      end

      it "sends a signature in the header" do
        expected = { 
          headers: { 
            "X_GITHUB_EVENT"  => "push",
            "X_HUB_SIGNATURE" => "sha1=f2d099c2ff67f1f52e1a0b9e8445306e1d30e6e4"
          },
        }
        expect(described_class).to receive(:post).with(anything, hash_including(expected))
        subject.send_payload(:push, payload)
      end
    end
  end
end