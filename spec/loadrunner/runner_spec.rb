describe Runner do
  describe '#execute' do
    subject { described_class.new repo: 'myrepo', event: 'pop', branch: 'slave' }

    before { subject.hooks_dir = 'spec/hooks' }

    it 'sets all options as env vars' do
      ENV['LOADRUNNER_REPO'] = nil
      ENV['LOADRUNNER_EVENT'] = nil
      ENV['LOADRUNNER_BRANCH'] = nil

      subject.execute

      expect(ENV['LOADRUNNER_REPO']).to eq 'myrepo'
      expect(ENV['LOADRUNNER_EVENT']).to eq 'pop'
      expect(ENV['LOADRUNNER_BRANCH']).to eq 'slave'
    end

    context 'when it does not find any hook' do
      it 'returns false' do
        expect(subject.execute).to be false
      end

      it 'returns matching hooks list' do
        subject.execute
        actual = subject.response[:matching_hooks]
        expected = ['spec/hooks/global', 'spec/hooks/myrepo/global',
                    'spec/hooks/myrepo/pop', 'spec/hooks/myrepo/pop@branch=slave']
        expect(actual).to eq expected
      end

      it 'returns a meaningful error' do
        subject.execute
        actual = subject.response[:error]
        expected = /Could not find any hook/
        expect(actual).to match expected
      end
    end

    context 'when it finds at least one hook' do
      subject { described_class.new repo: 'myrepo', event: 'push', tag: 'production' }

      before do
        subject.hooks_dir = 'spec/fixtures/hooks'
      end

      after do
        subject.hooks_dir = nil
        File.delete 'secret.txt' if File.exist? 'secret.txt'
      end

      it 'returns true' do
        expect(subject.execute).to be true
      end

      it 'returns executed hooks list' do
        subject.execute
        actual = subject.response[:executed_hooks]
        expected = ['spec/fixtures/hooks/myrepo/push@tag=production']
        expect(actual).to eq expected
      end

      it 'returns matching hooks list' do
        subject.execute
        actual = subject.response[:matching_hooks]
        expected = [
          'spec/fixtures/hooks/global',
          'spec/fixtures/hooks/myrepo/global',
          'spec/fixtures/hooks/myrepo/push',
          'spec/fixtures/hooks/myrepo/push@tag=production',
          'spec/fixtures/hooks/myrepo/push@tag',
        ]
        expect(actual).to eq expected
      end

      it 'executes the hooks' do
        File.delete 'secret.txt' if File.exist? 'secret.txt'
        subject.execute
        sleep 2
        expect(File.read 'secret.txt').to eq "There is no spoon\n"
      end
    end
  end
end
