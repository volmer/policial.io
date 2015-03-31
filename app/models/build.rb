class Build < ActiveRecord::Base
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
    Octokit.create_status(
      repo,
      sha,
      state,
      context: Rails.application.config.status_context,
      target_url: url,
      description: I18n.t(state, scope: 'build.description')
    )
  end

  def to_s
    "Build ##{id}"
  end

  private

  def url
    Rails.application.routes.url_helpers.build_url(
      self, Rails.application.config.default_url_options
    )
  end
end
