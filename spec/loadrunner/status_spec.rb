require 'spec_helper'

describe Status do
  subject { described_class }

  describe "status" do
    let(:expected) { OpenStruct.new code: 200 }

    it "calls GitHub API" do
      expect_any_instance_of(GithubAPI).to receive(:status).and_return(expected)
      actual = subject.update repo: 'repo', sha: 'sha', state: 'pending'
      expect(actual).to eq expected
    end
  end
end
