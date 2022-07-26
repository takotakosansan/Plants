class Public::PostCommentsController < ApplicationController
  before_action :authenticate_customer!
  def create
    @post = Post.find(params[:post_id])
    comment = current_customer.post_comments.new(post_comment_params)
    comment.post_id = @post.id
    @post_comment = PostComment.new
    if comment.save
      redirect_to post_path(@post)
    else
      # @comment = current_customer.post_comments.new(post_comment_params)
      # @comment.post_id = @post.id
      @error_comment = comment
      render "public/posts/show"
    end
  end

  def destroy
    PostComment.find(params[:id]).destroy
    redirect_to post_path(params[:post_id])
  end

  private

  def post_comment_params
    params.require(:post_comment).permit(:comment)
  end
end
