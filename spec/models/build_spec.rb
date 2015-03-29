require 'rails_helper'

RSpec.describe Build, type: :model do
  let(:payload) { File.read('spec/support/payloads/pull_request_opened.json') }
  let(:build) { described_class.from_webhook(payload) }

  describe '.from_webhook' do
    it 'returns a Build initialized with the given payload' do
      expect(build.repo).to eq('volmer/shit')
      expect(build.pull_request).to eq(1)
      expect(build.user).to eq('volmer')
      expect(build.sha).to eq('4569f67a73e273165f993d45c60dbd2ebadae5a6')
      expect(build.state).to eq('pending')
      expect(build.payload).to eq(payload)
    end

    it 'is nil if payload is incomplete' do
      build = described_class.from_webhook('{}')
      expect(build).to be_nil
    end
  end

  describe '#send_status' do
    it 'creates a status on GitHub using the build attributes' do
      build.save!

      expect(Octokit).to receive(:create_status).with(
        'volmer/shit',
        '4569f67a73e273165f993d45c60dbd2ebadae5a6',
        'pending',
        context: 'code-review/policial',
        target_url: "http://localhost:3000/builds/#{build.id}",
        description: 'Your changes are under investigation.'
      )

      build.send_status
    end
  end

  describe '#to_s' do
    it 'is a label with the build id' do
      build.id = 123
      expect(build.to_s).to eq('Build #123')
    end
  end
end
