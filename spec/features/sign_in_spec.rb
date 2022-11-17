require 'rails_helper'

RSpec.feature 'Sign in', type: :feature do
  before do
    create(:user, email: 'user@example.com', password: 'foobar')
    visit new_user_session_path
  end

  scenario 'with valid inputs' do
    fill_in 'user_email', with: 'user@example.com'
    fill_in 'user_password', with: 'foobar'
    click_on 'Sign in'

    expect(page).to have_content('Signed in successfully')
  end

  context 'with invalid inputs' do
    scenario 'wrong credentials' do
      fill_in 'user_email', with: 'user@example.com'
      fill_in 'user_password', with: 'idontremembermypassword'
      click_on 'Sign in'

      expect(page).to have_content('Invalid Email or password')
    end

    scenario 'blank fields' do
      click_on 'Sign in'

      expect(page).to have_content('Invalid Email or password')
    end
  end
end
