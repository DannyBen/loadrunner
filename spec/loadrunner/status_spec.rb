describe Status do
  subject { described_class }

  describe 'status' do
    let(:response) { OpenStruct.new code: 200 }
    let(:github_api_double) { double GithubAPI, status: response }

    it 'calls GitHub API' do
      allow(GithubAPI).to receive(:new).and_return github_api_double
      allow(github_api_double).to receive(:status).and_return(response)

      expect(subject.update repo: 'repo', sha: 'sha', state: 'pending')
        .to eq response
    end
  end
end
