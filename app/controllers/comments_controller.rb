class CommentsController < ApplicationController
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
end
