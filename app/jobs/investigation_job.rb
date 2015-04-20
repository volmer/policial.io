class InvestigationJob < ActiveJob::Base
  queue_as :default

  def perform(build)
    violations = investigate(build)

    accuse(build, violations)
  rescue
    build.error!
    raise
  ensure
    build.send_status
  end

  private

  def investigate(build)
    detective = Policial::Detective.new(build.repository.github_client)
    event = Policial::PullRequestEvent.new(JSON.parse(build.payload))
    detective.brief(event)

    detective.investigate
  end

  def accuse(build, violations)
    if violations.present?
      build.failure!

      build.violations = violations.flat_map do |violation|
        Violation.from_policial(violation)
      end
    else
      build.success!
    end
  end
end
