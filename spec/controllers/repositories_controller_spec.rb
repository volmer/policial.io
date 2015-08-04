require 'rails_helper'

RSpec.describe RepositoriesController, type: :controller do
  let(:valid_attributes) { { name: 'volmer/repo' } }
  let(:current_user) { User.create!(uid: 123) }

  before { sign_in(current_user) }

  describe 'GET #index' do
    it 'returns a successful response' do
      allow_any_instance_of(Octokit::Client).to receive(
        :repositories).and_return([])
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #new' do
    it 'returns a successful response' do
      allow_any_instance_of(Octokit::Client).to receive(
        :repositories).and_return([])
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      before do
        allow_any_instance_of(Octokit::Client).to receive(
          :create_hook).and_return({})
      end

      it 'creates a new repository' do
        expect do
          post :create, repository: valid_attributes
        end.to change(Repository, :count).by(1)
      end

      it 'redirects to the repository list with a successful message' do
        post :create, repository: valid_attributes
        expect(response).to redirect_to(repositories_url)
        expect(flash[:success]).to eq('Repository assimilated.')
      end
    end

    context 'with invalid params' do
      it 'redirects to the repository list with an error message' do
        post :create, repository: { name: '' }
        expect(response).to redirect_to(repositories_url)
        expect(flash[:alert]).to eq('Error trying to link the repository.')
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:repository) { Repository.create!(valid_attributes) }

    context 'current user has access to the repository' do
      before { current_user.repositories << repository }

      it 'destroys the requested repository' do
        expect do
          delete :destroy, id: repository.to_param
        end.to change(Repository, :count).by(-1)
      end

      it 'redirects to the repository list with a successful message' do
        delete :destroy, id: repository.to_param
        expect(response).to redirect_to(repositories_url)
        expect(flash[:success]).to eq('Repository disabled.')
      end
    end

    context 'current user does not have access to the repository' do
      it 'returns 404 not found' do
        delete :destroy, id: repository.to_param
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'GET #show' do
    let!(:repository) { Repository.create!(valid_attributes) }

    it 'fails with 404 when repo not found' do
      get :show, id: 'non/ecziste'
      expect(response).to have_http_status(:not_found)
    end

    it 'returns 404 when user does not have access to the repository' do
      get :show, id: repository.to_param
      expect(response).to have_http_status(:not_found)
    end

    it 'returns success when user has access to the repository' do
      repository.users << current_user
      get :show, id: repository.to_param
      expect(response).to have_http_status(:success)
    end
  end
end
