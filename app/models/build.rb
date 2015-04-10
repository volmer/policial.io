class Build < ActiveRecord::Base
  belongs_to :repository, foreign_key: 'repo', primary_key: 'name'
  has_many :violations, dependent: :destroy

  validates :pull_request, presence: true
  validates :repo, presence: true
  validates :user, presence: true
  validates :sha, presence: true
  validates :payload, presence: true
  enum state: [:pending, :success, :error, :failure]

  # Public: Populate a new Build based on the given payload.
  #
  # payload - The String with the Pull Request payload.
  #
  # Returns a new Build with the pull request information.
  def self.from_webhook(payload)
    json = JSON.parse(payload)
    pull_request = Policial::PullRequestEvent.new(json).pull_request
    return if pull_request.nil?

    new(
      pull_request: pull_request.number,
      repo: pull_request.repo,
      user: pull_request.user,
      sha: pull_request.head_commit.sha,
      payload: payload
    )
  end

  def send_status
    repository.github_client.create_status(
      repo,
      sha,
      state,
      context: Rails.application.config.status_context,
      target_url: url,
      description: description
    )
  end

  def to_s
    "Build ##{id}"
  end

  def description
    I18n.t(state, scope: 'build.description')
  end

  private

  def url
    Rails.application.routes.url_helpers.build_url(
      repo, self, Rails.application.config.default_url_options
    )
  end
end
