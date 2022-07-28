class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :set_current_user_notifications

  def set_current_user_notifications
    return unless user_signed_in?

    @current_user_unread_notifications_count = current_user.notifications.unread.count
    current_user.notifications.update(read: true)
    @current_user_notifications = current_user.notifications
  end
end
