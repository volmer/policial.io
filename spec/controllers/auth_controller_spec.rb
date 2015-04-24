require 'rails_helper'

RSpec.describe AuthController, type: :controller do
  let(:credentials) do
    { credentials: { token: 'token123' },
      extra: { raw_info: { name: 'Arthur', avatar_url: '', login: 'arthurnn' } }
    }
  end

  before do
    OmniAuth.config.add_mock(:github, credentials)
    request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:github]
  end

  after do
    OmniAuth.config.mock_auth[:github] = nil
  end

  describe 'GET #github' do
    let(:user) { @controller.send(:current_user) }

    it 'redirects to home' do
      get :github
      expect(response).to redirect_to(:root)
    end

    it 'saves the current user in the session' do
      get :github
      expect(session[:current_user]).to_not be_nil
    end

    it 'saves the user as json' do
      get :github
      expect(session[:current_user]).to be_kind_of(Hash)
    end

    it 'returns the User model' do
      get :github
      expect(user).to be_kind_of(User)
    end

    it 'saves the login' do
      get :github
      expect(user.login).to eq('arthurnn')
    end
  end

  describe 'GET #sign_out' do
    before do
      session[:current_user] = User.new(token: 'foobar').as_json
    end

    it 'cleans the user session' do
      get :sign_out
      expect(session[:current_user]).to be_nil
    end
  end
end
