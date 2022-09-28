class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :set_current_user_notifications

  def set_current_user_notifications
    return unless user_signed_in?

    @current_user_notifications = current_user.notifications.order(created_at: :desc)
    @current_user_unread_notifications_count = @current_user_notifications.count { |notification| !notification.read }

    return if @current_user_unread_notifications_count.zero?

    current_user.notifications.unread.update_all(read: true)
  end
end
