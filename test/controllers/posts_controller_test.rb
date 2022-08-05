require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:first)
  end

  test "redirected if not logged in" do
    sign_out users(:first)

    get root_path
    assert_response :redirect
  end

  test "login user should get Posts#index" do
    get root_path
    assert_select 'h1', 'Posts#index'
  end
end
