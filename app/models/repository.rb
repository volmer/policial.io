class Repository < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :builds, foreign_key: 'repo', primary_key: 'name'

  validates :name, presence: true, uniqueness: true

  before_create :create_webhook, if: :github_token?
  before_destroy :remove_webhook, if: :github_token?

  def github_client
    Octokit::Client.new(access_token: github_token)
  end

  def to_param
    name
  end

  def to_s
    name
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

  def remove_webhook
    github_client.remove_hook(name, webhook_id)
  end
end
