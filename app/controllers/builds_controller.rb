class BuildsController < ApplicationController
  rescue_from(JSON::ParserError) { head(:bad_request) }

  def index
    @builds = Build.order(created_at: :desc)
  end

  def show
    @build = Build.find(params[:id])
  end

  def create
    @build = Build.from_webhook(request.raw_post)

    if @build
      @build.save!

      @build.send_status

      render(json: @build, status: :created)
    else
      head(:bad_request)
    end
  end
end
