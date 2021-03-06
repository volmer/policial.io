require 'rails_helper'

RSpec.describe BuildsController, type: :controller do
  let(:payload) { File.read('spec/support/payloads/pull_request_opened.json') }
  let(:build) { Build.from_webhook(payload) }
  let(:valid_session) { {} }
  let!(:repo) { Repository.create!(name: 'volmer/shit') }

  describe 'GET #show' do
    before { build.save! }

    it 'returns a successful response' do
      get :show, id: build.to_param, repository_id: 'volmer/shit'
      expect(response).to have_http_status(:success)
    end

    it 'fails with 404 when repo not found' do
      get :show, id: build.to_param, repository_id: 'foo/bar'
      expect(response).to have_http_status(:not_found)
    end

    context 'with a build from a private repository' do
      before { repo.update!(private: true) }

      it 'returns 404 when user is not signed in' do
        get :show, id: build.to_param, repository_id: 'volmer/shit'
        expect(response).to have_http_status(:not_found)
      end

      it 'returns 404 when user does not have access to the repository' do
        sign_in(User.create!(uid: 123))
        get :show, id: build.to_param, repository_id: 'volmer/shit'
        expect(response).to have_http_status(:not_found)
      end

      it 'returns success when user has access to the build repository' do
        user = User.create!(uid: 123)
        sign_in(user)
        repo.users << user
        get :show, id: build.to_param,  repository_id: 'volmer/shit'
        expect(response).to have_http_status(:success)
      end
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

      it 'queues an InvestigationJob' do
        expect(
          InvestigationJob
        ).to receive(:perform_later).with(an_instance_of(Build))

        post(:create, payload, format: :json)
      end

      it 'returns :created' do
        post(:create, payload, format: :json)
        expect(response).to have_http_status(:created)
      end

      context 'with ingnorable pull request events' do
        before do
          expect_any_instance_of(Policial::PullRequestEvent).to receive(
            :should_investigate?
          ).and_return(false)
        end

        it 'does not create a Build' do
          expect { post(:create, payload, format: :json) }.not_to change(
            Build, :count
          )
        end
      end
    end

    context 'with invalid params' do
      it 'returns 400 bad request' do
        post(:create, nil, format: :json)
        expect(response).to have_http_status(:bad_request)

        post(:create, 'invalid', format: :json)
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
