class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :set_current_user_notifications

  def set_current_user_notifications
    return unless user_signed_in?

    @current_user_notifications = current_user.notifications.order(created_at: :desc).pluck(:body, :read)
    return if @current_user_notifications.all? { |_body, read| read }

    current_user.notifications.unread.update_all(read: true)
  end
end
