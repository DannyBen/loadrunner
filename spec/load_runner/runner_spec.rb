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
      subject { described_class.new repo: 'myrepo', event: 'push', tag: 'production' }

      before do
        subject.handlers_dir = 'spec/fixtures/handlers'
      end

      after do
        subject.handlers_dir = nil
        File.delete 'secret.txt' if File.exist? 'secret.txt'
      end

      it "returns true" do
        expect(subject.execute).to be true
      end

      it "returns executed handlers list" do
        subject.execute
        actual = subject.response[:executed_handlers]
        expected = ["spec/fixtures/handlers/myrepo/push@tag=production"]
        expect(actual).to eq expected
      end

      it "executes the handlers" do
        File.delete 'secret.txt' if File.exist? 'secret.txt'
        subject.execute
        sleep 2
        expect(File.read 'secret.txt').to eq "There is no spoon\n"
      end
    end

  end
end
