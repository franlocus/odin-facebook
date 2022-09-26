class CommentsController < ApplicationController
  before_action :set_comment, only: [:destroy]

  def create
    @comment = current_user.comments.build(comment_params)
    if @comment.save
      redirect_to post_path(@comment.post), notice: 'Comment created successfully!'
    else
      flash[:comment_errors] = @comment.errors.full_messages
      redirect_back fallback_location: root_path
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    redirect_back fallback_location: root_path, notice: 'Comment deleted successfully!'
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :post_id)
  end

  def set_comment
    return if (@comment = Comment.find_by_id(params[:id]))

    redirect_back fallback_location: root_path, alert: 'Sorry, comment not found!'
  end
end
