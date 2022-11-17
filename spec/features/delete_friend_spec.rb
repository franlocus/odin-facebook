require 'rails_helper'

RSpec.feature 'Delete friend', type: :feature do
  let!(:user) { create(:user) }
  let!(:friend) { create(:user) }
  let!(:friendship) { create(:friendship, user:, friend:, accepted: true) }

  before do
    sign_in(user)
    visit users_path
  end

  scenario 'can delete a friend' do
    click_on(friend.email)
    expect(page).to have_content("Profile #{friend.email}")

    click_on('Delete friend')

    expect(page).to have_content('Friend deleted successfully')
    expect(page).to have_current_path(users_path)
  end

  scenario 'can not delete the friend if he did it before' do
    click_on(friend.email)
    expect(page).to have_content("Profile #{friend.email}")

    friendship.destroy
    click_on('Delete friend')

    expect(page).to have_content('Sorry, friendship not found! Try again')
    expect(page).to have_current_path(users_path)
  end
end
