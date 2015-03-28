require 'rails_helper'

RSpec.describe Build, type: :model do
  let(:payload) { File.read('spec/support/payloads/pull_request_opened.json') }

  describe '.from_webhook' do
    it 'returns a Build initialized with the given payload' do
      build = described_class.from_webhook(payload)

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
end
