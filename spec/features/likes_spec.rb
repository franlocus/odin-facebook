require 'rails_helper'

RSpec.feature 'Likes', type: :feature do
  let!(:user) { create(:user) }
  let!(:friend) { create(:user) }
  let!(:post) { create(:post, author: user) }
  let!(:post_of_friend) { create(:post, author: friend) }

  before { sign_in(user) }

  context 'with posts from user' do
    before { visit user_path(user) }

    scenario 'can like it' do
      click_on 'Like'

      expect(page).to have_content('Liked')
      expect(page).to have_content('Likes: 1 person')
    end

    scenario 'can unlike it' do
      create(:like, user:, post:)
      refresh
      click_on 'Unlike'

      expect(page).to have_content('Likes: nobody')
    end

    scenario 'can not like it twice' do
      create(:like, user:, post:)
      click_on 'Like'

      expect(page).to have_content('You already like it')
    end

    scenario 'can not unlike if it is not liked' do
      like = create(:like, user:, post:)
      refresh
      like.destroy
      click_on 'Unlike'

      expect(page).to have_content('Sorry, like not found')
      expect(page).to have_content('Like')
    end
  end

  context 'with posts from friend' do
    scenario 'can like it' do
      visit user_path(friend)
      click_on 'Like'

      expect(page).to have_content('Liked')
      expect(page).to have_content('Likes: 1 person')
    end

    scenario 'can unlike it' do
      create(:like, user:, post: post_of_friend)

      visit user_path(friend)
      click_on 'Unlike'

      expect(page).to have_content('Likes: nobody')
    end
  end
end
