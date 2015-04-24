require 'rails_helper'

feature 'User session' do
  background do
    OmniAuth.config.mock_auth[:github] = {
      extra: { raw_info: { name: 'Krystosterone' } },
      credentials: { token: '123abc' }
    }

    visit '/'
  end

  scenario 'Sign in/sign out' do
    click_on 'Sign in'
    expect(page).to have_content('Krystosterone')

    click_on 'Sign out'
    expect(page).not_to have_content('Krystosterone')
  end
end
