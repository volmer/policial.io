require 'rails_helper'

RSpec.describe Repository, type: :model do
  let(:repo) { described_class.new(name: 'arthurnn/policial.io') }
  let(:github_client) { double }

  describe '#create_webhook' do
    it 'creates the webhook on GitHub' do
      repo.github_token = 'foobar'
      allow(repo).to receive(:github_client).and_return(github_client)
      expect(github_client).to receive(:create_hook).with(
        'arthurnn/policial.io',
        'web',
        { url: 'http://localhost:4000/builds',
          content_type: 'json' },
        events: %w(push pull_request)
      ).and_return(id: 1)
      repo.save
    end

    it 'saves the id when github_token exists' do
      repo.github_token = 'foobar'
      allow(repo).to receive(:github_client).and_return(github_client)
      expect(github_client).to receive(:create_hook).and_return(id: 1)
      repo.save
      expect(repo.webhook_id).to eq(1)
    end
  end

  describe '#remove_webhook' do
    it 'removes the webhook from GitHub' do
      repo.webhook_id = 1
      repo.save!
      repo.github_token = 'foobar'
      allow(repo).to receive(:github_client).and_return(github_client)

      expect(github_client).to receive(:remove_hook).with(
        'arthurnn/policial.io', 1
      )
      repo.destroy!
    end
  end
end
