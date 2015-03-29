require 'rails_helper'

RSpec.describe BuildsController, type: :controller do
  let(:payload) { File.read('spec/support/payloads/pull_request_opened.json') }
  let(:build) { Build.from_webhook(payload) }
  let(:valid_session) { {} }

  describe 'GET #index' do
    it 'returns a successful response' do
      get(:index)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #show' do
    it 'returns a successful response' do
      build.save!
      get(:show, id: build.to_param)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      let!(:create_status_request) do
        stub_request(
          :post,
          'https://api.github.com/repos/volmer/shit/statuses/4569f67a73e273165'\
          'f993d45c60dbd2ebadae5a6'
        )
      end

      it 'creates a new Build' do
        expect { post(:create, payload, format: :json) }.to change(
          Build, :count
        ).by(1)
      end

      it 'creates a status on GitHub' do
        post(:create, payload, format: :json)

        expect(create_status_request).to have_been_requested
      end

      it 'returns :created' do
        post(:create, payload, format: :json)
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid params' do
      it 'returns 400 bad request' do
        post(:create, '{}', format: :json)
        expect(response).to have_http_status(:bad_request)

        post(:create, nil, format: :json)
        expect(response).to have_http_status(:bad_request)

        post(:create, 'invalid', format: :json)
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
