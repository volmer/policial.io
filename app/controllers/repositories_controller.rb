class RepositoriesController < ApplicationController
  before_action :require_login

  def index
    @repositories = current_user.client.repositories.map do |repo|
      Repository.find_or_initialize_by(name: repo.full_name)
    end
  end

  def create
    @repository = Repository.new(repository_params)
    @repository.github_token = current_user.token
    if @repository.save
      redirect_to repositories_url, success: 'Repository assimilated.'
    else
      redirect_to repositories_url,
                  alert: 'Error trying to link the repository.'
    end
  end

  def destroy
    @repository = Repository.find(params[:id])
    @repository.destroy!
    redirect_to repositories_url, success: 'Repository disabled.'
  end

  private

  def repository_params
    params.require(:repository).permit(:name)
  end
end
