require 'spec_helper'

describe Runner do
  describe "#execute" do
    subject { described_class.new repo: 'myrepo', event: 'pop', branch: 'slave' }

    it "sets all options as env vars" do
      ENV['REPO'] = nil
      ENV['EVENT'] = nil
      
      subject.execute
      
      expect(ENV['REPO']).to eq 'myrepo'
      expect(ENV['EVENT']).to eq 'pop'
    end

    context "when it does not find any handler" do
      it "returns false" do
        expect(subject.execute).to be false
      end

      it "returns matching handlers list" do
        subject.execute
        actual = subject.response[:matching_handlers]
        expected = ["handlers/myrepo/pop", "handlers/myrepo/pop@branch=slave"]
        expect(actual).to eq expected
      end

      it "returns a meaningful error" do
        subject.execute
        actual = subject.response[:error]
        expected = /Could not find any handler/
        expect(actual).to match expected        
      end
    end

    context "when it finds at least one handler" do
      it "returns true"
      it "returns executed handlers list"
      it "executes the handlers"
    end

  end
end
