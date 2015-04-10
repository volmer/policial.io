class BuildsController < ApplicationController
  rescue_from(JSON::ParserError) { head(:bad_request) }

  before_action :ensure_suspicious_event, only: :create
  before_action :find_repo, only: [:index, :show]

  def index
    @builds = @repo.builds.order(created_at: :desc)
  end

  def show
    @build = Build.find(params[:id])
    @violations = @build.violations.order(filename: :asc, line_number: :asc)
  end

  def create
    @build = Build.from_webhook(request.raw_post)

    if @build
      @build.save!
      @build.send_status
      InvestigationJob.perform_later(@build)
      render(json: @build, status: :created)
    else
      head(:bad_request)
    end
  end

  private

  def ensure_suspicious_event
    event = Policial::PullRequestEvent.new(JSON.parse(request.raw_post))
    render(nothing: true) unless event.should_investigate?
  end

  def find_repo
    @repo = Repository.find_by!(name: params[:repo])
  end
end
