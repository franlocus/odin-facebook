require 'rails_helper'

RSpec.feature 'Posts', type: :feature do
  let!(:user) { create(:user) }
  let!(:post) { create(:post, author: user) }

  before do
    sign_in(user)
    visit posts_path
  end

  scenario 'can create post with text' do
    fill_in 'post_content', with: 'Yay, this is my first post!'
    click_on 'Create Post'

    expect(page).to have_current_path(post_path(Post.last))
    expect(page).to have_content('Post created successfully!')
    expect(page).to have_content('Yay, this is my first post!')
  end

  scenario 'can create post with text and image' do
    fill_in 'post_content', with: 'Yay, this post has text and image!'
    attach_file 'post_images', 'spec/factories/example_image.jpeg'
    click_on 'Create Post'

    expect(Post.last.images).to be_attached
    expect(page).to have_content('Yay, this post has text and image!')
    expect(page).to have_content('Post created successfully!')
  end

  scenario 'can not create empty post' do
    fill_in 'post_content', with: ''
    click_on 'Create Post'

    expect(page).to have_current_path(posts_path)
    expect(page).to have_content("Content can't be blank")
  end

  scenario 'can delete his post', js: true do
    accept_confirm do
      click_on 'Delete post'
    end
    expect(page).to have_content('Post deleted successfully!')
  end

  scenario 'can not delete an already deleted post', js: true do
    post.destroy
    accept_confirm do
      click_on 'Delete post'
    end
    expect(page).to have_content('Sorry, post not found!')
  end

  context 'when friends have posts' do
    before do
      friend = create(:user)
      create(:friendship, user:, friend:, accepted: true)
      create(:post, author: friend, content: 'Post by some guy')
      refresh
    end

    scenario 'can see posts from friends on index' do
      expect(page).to have_content('Read full post with comments')
      expect(page).to have_content('Post by some guy')
    end

    scenario 'can not delete post from other author profile' do
      visit user_path(user.friends.last)

      expect(page).to have_content('Read full post with comments')
      expect(page).to have_content('Post by some guy')
      expect(page).not_to have_content('Delete post')
    end
  end
end
