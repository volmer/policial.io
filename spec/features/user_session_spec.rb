require 'rails_helper'

feature 'User session' do
  background do
    OmniAuth.config.mock_auth[:github] = {
      uid: 123, info: { name: 'Krystosterone' },
      credentials: { token: '123abc' }
    }
    allow_any_instance_of(Octokit::Client).to receive_messages(repositories: [])
    visit '/'
  end

  scenario 'Sign in/sign out' do
    click_on 'Sign in with GitHub'
    expect(page).to have_content('Krystosterone')

    click_on 'Sign out'
    expect(page).not_to have_content('Krystosterone')
    expect(page).to have_link('Sign in with GitHub')
  end
end
