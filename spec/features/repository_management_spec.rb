require 'rails_helper'

feature 'Repository Management' do
  background do
    OmniAuth.config.mock_auth[:github] = {
      uid: 123, info: { name: 'Krystosterone' },
      credentials: { token: '123abc' }
    }
    allow_any_instance_of(Octokit::Client).to receive_messages(
      repositories: [double(full_name: 'volmer/repo', private: false)],
      create_hook: {}
    )
    visit '/'
    click_on 'Sign in'
  end

  scenario 'Enable repository' do
    click_on 'Add repository'
    within('[data-repo="volmer/repo"]') { click_on 'Enable' }

    expect(page).to have_content('Repository assimilated.')
  end

  scenario 'Disable repository' do
    repo = Repository.create!(name: 'volmer/repo')
    User.find_by(uid: '123').repositories << repo

    visit '/'
    click_on 'volmer/repo'
    click_on 'Disable'

    expect(page).to have_content('Repository disabled.')
  end
end
