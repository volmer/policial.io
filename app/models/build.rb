class Build < ActiveRecord::Base
  validates :pull_request, presence: true
  validates :repo, presence: true
  validates :user, presence: true
  validates :sha, presence: true
  validates :payload, presence: true
  validates :state,
            presence: true,
            inclusion: %w(pending success error failure)

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

  def to_s
    "Build ##{id}"
  end
end
