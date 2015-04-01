require 'rails_helper'

RSpec.describe AuthController, type: :controller do
  let(:credentials) do
    { credentials: { token: 'token123' },
      extra: { raw_info: { name: 'Arthur', avatra_url: '' } }
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
  end

  describe 'GET #logout' do
    before do
      session[:current_user] = User.new(token: 'foobar').as_json
    end

    it 'cleans the user session' do
      get :logout
      expect(session[:current_user]).to be_nil
    end
  end
end
