require 'rails_helper'

RSpec.feature 'Sign up', type: :feature do
  before { visit new_user_registration_path }

  scenario 'with valid inputs' do
    fill_in 'user_email', with: 'user@example.com'
    fill_in 'user_password', with: 'foobar'
    fill_in 'user_password_confirmation', with: 'foobar'
    click_on 'Sign up'

    expect(page).to have_content('You have signed up successfully')
  end

  scenario 'with invalid inputs' do
    fill_in 'user_email', with: ''
    fill_in 'user_password', with: 'foobar'
    fill_in 'user_password_confirmation', with: 'barfoo'
    click_on 'Sign up'

    expect(page).to have_content("Email can't be blank")
    expect(page).to have_content('Email is invalid')
    expect(page).to have_content("Password confirmation doesn't match Password")
  end
end