require 'spec_helper'

describe GithubAPI do
  let(:sha) { 'S4mpl3Sh4C0d3' }
  let(:repo) { 'myrepo' }
  let(:opts) do
    {
      state: :success, context: 'specs',
      description: 'running specs', target_url: 'myci.com'
    }
  end

  describe '#status' do
    it 'posts to github' do
      expected_url = "/repos/#{repo}/statuses/#{sha}"
      expected_opts = { body: opts.to_json }

      expect(described_class).to receive(:post).with(expected_url, hash_including(expected_opts))

      subject.status repo, sha, opts
    end
  end
end
