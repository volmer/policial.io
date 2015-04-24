require 'rails_helper'

RSpec.describe RepositoriesController, type: :controller do
  let(:valid_attributes) { { name: 'volmer/repo' } }
  let(:valid_session) { { current_user: { name: 'volmer' } } }

  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new repository' do
        expect do
          post :create, { repository: valid_attributes }, valid_session
        end.to change(Repository, :count).by(1)
      end

      it 'redirects to the repository list with a successful message' do
        post :create, { repository: valid_attributes }, valid_session
        expect(response).to redirect_to(repositories_url)
        expect(flash[:success]).to eq('Repository assimilated.')
      end
    end

    context 'with invalid params' do
      it 'redirects to the repository list with an error message' do
        post :create, { repository: { name: '' } }, valid_session
        expect(response).to redirect_to(repositories_url)
        expect(flash[:alert]).to eq('Error trying to link the repository.')
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:repository) { Repository.create!(valid_attributes) }

    it 'destroys the requested repository' do
      expect do
        delete :destroy, { id: repository.to_param }, valid_session
      end.to change(Repository, :count).by(-1)
    end

    it 'redirects to the repository list with a successful message' do
      delete :destroy, { id: repository.to_param }, valid_session
      expect(response).to redirect_to(repositories_url)
      expect(flash[:success]).to eq('Repository disabled.')
    end
  end
end
