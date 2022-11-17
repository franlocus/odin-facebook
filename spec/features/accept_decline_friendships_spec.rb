require 'rails_helper'

RSpec.feature 'Accept and decline friendships', type: :feature do
  let!(:user) { create(:user) }
  let!(:friend) { create(:user) }
  let!(:friendship) { create(:friendship, user: friend, friend: user) }

  before do
    sign_in(user)
    visit users_path
  end

  scenario 'can accept it' do
    click_on('Accept request')

    expect(page).to have_content('Now you are friends!')

    expect(page).to have_current_path(user_path(friend))
    expect(page).to have_content("Profile #{friend.email}")
  end

  scenario 'can not accept if the request was cancelled previously' do
    friendship.destroy

    click_on('Accept request')

    expect(page).to have_content('Sorry, friendship not found! Try again')
  end

  scenario 'can not accept if the other user doesnt exist' do
    friend.destroy

    click_on('Accept request')

    expect(page).to_not have_content("Profile #{friend.email}")
    expect(page).to have_content('Sorry, friendship not found! Try again')
  end

  scenario 'can decline it' do
    click_on('Decline request')

    expect(page).to have_current_path(users_path)
    expect(page).to have_content('Request cancelled successfully')
  end

  scenario 'can not decline it if the request was cancelled previously' do
    friendship.destroy

    click_on('Decline request')

    expect(page).to have_content('Sorry, friendship not found! Try again')
  end
end
