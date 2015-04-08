class RepositoriesController < ApplicationController
  before_action :require_login

  def index
    @repositories = current_user.client.repositories.map do |repo|
      Repository.find_or_initialize_by(name: repo.full_name)
    end
  end

  def create
    @repository = Repository.new(name: params[:repo])
    @repository.github_token = current_user.token
    if @repository.save
      redirect_to repositories_url, success: 'Repository assimilated.'
    else
      redirect_to repositories_url,
                  error: 'Error trying to link the repository.'
    end
  end
end
