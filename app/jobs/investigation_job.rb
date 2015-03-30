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
    event = Policial::PullRequestEvent.new(JSON.parse(build.payload))
    investigation = Policial::Investigation.new(event.pull_request)

    investigation.run
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
