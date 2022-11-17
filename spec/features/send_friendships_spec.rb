require 'rails_helper'

RSpec.feature 'Send friendships', type: :feature do
  let!(:user) { create(:user) }
  let!(:friend) { create(:user) }

  before do
    sign_in(user)
    visit users_path
  end

  scenario 'can send' do
    click_on('Add friend')

    expect(page).to have_current_path(user_path(friend))
    expect(page).to have_content('Great, now the user must confirm your friend request')
    expect(page).to have_content("Profile #{friend.email}")
  end

  scenario 'can not send if there is a pending request from the other user' do
    create(:friendship, user: friend, friend: user)
    click_on('Add friend')

    expect(page).to_not have_content("Profile #{friend.email}")
    expect(page).to have_content('You already have a pending request!')
  end

  scenario 'can not send if the other user doesnt exist anymore' do
    friend.destroy
    click_on('Add friend')

    expect(page).to_not have_content("Profile #{friend.email}")
    expect(page).to have_content('Sorry, user not found!')
  end

  context 'when cancelling sent requests' do
    let!(:friendship) { create(:friendship, user:, friend:) }
    before { refresh }

    scenario 'can cancel request' do
      click_on('Cancel request')

      expect(page).to have_current_path(users_path)
      expect(page).to have_content('Request cancelled successfully')
    end

    scenario 'can not cancel if the request was cancelled previously' do
      friendship.destroy
      click_on('Cancel request')

      expect(page).to have_content('Sorry, friendship not found! Try again')
    end
  end
end