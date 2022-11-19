require 'rails_helper'

RSpec.feature 'Comments', type: :feature do
  let!(:user) { create(:user) }
  let!(:person) { create(:user) }
  let!(:post) { create(:post, author: user) }

  before { sign_in(user) }

  context 'with post from user' do
    let!(:user_comment) { create(:comment, post:, commenter: user, body: 'I will delete this comment soon') }

    before { visit post_path(post) }

    scenario 'can comment on it' do
      fill_in 'comment_body', with: 'Im commenting my post'
      click_on 'Create'

      expect(page).to have_content('Comment created successfully')
      expect(page).to have_content('Im commenting my post')
    end

    scenario 'can delete a comment on it' do
      click_on 'Delete comment'

      expect(page).to have_content('Comment deleted successfully')
      expect(page).to have_content("This post doesn't have comments yet")
      expect(page).not_to have_content('I will delete this comment soon')
    end

    scenario 'can not delete an already deleted comment' do
      user_comment.destroy
      click_on 'Delete comment'

      expect(page).to have_content('Sorry, comment not found')
    end
  end

  context 'with post from other person' do
    let!(:post_of_other_person) { create(:post, author: person) }

    before do
      create(:comment, post: post_of_other_person, commenter: person, body: 'This is my best post')
      visit post_path(post_of_other_person)
    end

    scenario 'can comment on it' do
      fill_in 'comment_body', with: 'Hey buddy, good post!'
      click_on 'Create'

      expect(page).to have_content('Comment created successfully')
      expect(page).to have_content('Hey buddy, good post!')
    end

    scenario 'can delete an authored comment on it' do
      create(:comment, post: post_of_other_person, commenter: user, body: 'Goodbye buddy')
      refresh
      click_on 'Delete comment'

      expect(page).not_to have_content('Goodbye buddy')
      expect(page).to have_content('Comment deleted successfully')
    end

    scenario 'can not delete a comment from other person' do
      expect(page).to have_content('This is my best post')
      expect(page).not_to have_content('Delete comment')
    end
  end
end
