class Repository < ActiveRecord::Base
  before_create :create_webhook, if: :github_token?

  def github_client
    Octokit::Client.new(access_token: github_token)
  end

  private

  def create_webhook
    hook = github_client.create_hook(
      name, 'web',
      { url: webhook_url, content_type: 'json' },
      events: %w(push pull_request)
    )
    self.webhook_id = hook[:id]
  end

  def webhook_url
    Rails.application.routes.url_helpers.builds_url(
      Rails.application.config.default_url_options
    )
  end
end
