describe Client do
  describe '#send_event' do
    context 'without arguments' do
      let(:payload) { { ref: nil, repository: { name: nil } } }

      it 'builds and sends a payload' do
        expect(subject).to receive(:send_payload).with(:push, payload)
        subject.send_event
      end
    end

    context 'with arguments' do
      let(:payload) { { ref: 'refs/heads/test', repository: { name: 'myrepo' } } }

      it 'builds and sends a payload' do
        expect(subject).to receive(:send_payload).with(:ping, payload)
        subject.send_event :ping, ref: 'refs/heads/test', repo: 'myrepo'
      end
    end

    context 'with branch argument' do
      it 'converts it to ref' do
        expected = { ref: 'refs/heads/branchy' }
        expect(subject).to receive(:send_payload).with(anything, hash_including(expected))
        subject.send_event :push, branch: 'branchy'
      end
    end

    context 'with tag argument' do
      it 'converts it to ref' do
        expected = { ref: 'refs/tags/tagly' }
        expect(subject).to receive(:send_payload).with(anything, hash_including(expected))
        subject.send_event :push, tag: 'tagly'
      end
    end

    context 'with a full name repo' do
      it 'extracts its short name' do
        expected = { repository: { name: 'myrepo', full_name: 'me/myrepo' } }
        expect(subject).to receive(:send_payload).with(anything, hash_including(expected))
        subject.send_event :push, repo: 'me/myrepo'
      end
    end
  end

  describe '#send_payload' do
    let(:payload) { { ref: 'refs/heads/test', repository: { name: 'myrepo' } } }

    it 'sends a post http message' do
      expect(described_class).to receive(:post).with('', any_args)
      subject.send_payload(:push, payload)
    end

    it 'converts payload to json' do
      expected = {
        body:    payload.to_json,
        headers: {
          'X-GitHub-Event' => 'push',
          'Content-Type'   => 'application/json',
        },
      }

      expect(described_class).to receive(:post).with(anything, expected)
      subject.send_payload(:push, payload)
    end

    context 'when form encoding is requested' do
      subject { described_class.new encoding: :form }

      it 'converts payload to x-www-form-urlencoded' do
        body = URI.encode_www_form({ payload: payload.to_json })
        expected = { body:    body,
                     headers: { 'X-GitHub-Event' => 'push', 'Content-Type' => 'application/x-www-form-urlencoded' } }
        expect(described_class).to receive(:post).with(anything, expected)
        subject.send_payload(:push, payload)
      end
    end

    context 'when secret_token is set' do
      before do
        subject.secret_token = '123'
      end

      it 'sends a signature in the header' do
        expected = {
          headers: {
            'X-GitHub-Event'  => 'push',
            'X-Hub-Signature' => 'sha1=f2d099c2ff67f1f52e1a0b9e8445306e1d30e6e4',
            'Content-Type'    => 'application/json',
          },
        }
        expect(described_class).to receive(:post).with(anything, hash_including(expected))
        subject.send_payload(:push, payload)
      end
    end
  end
end
