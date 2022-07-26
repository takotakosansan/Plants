class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!
  
  def show
    @post = Post.find(params[:id])
    @post_tags = @post.tags
    @comment = @post.post_comments.page(params[:page]).per(3)
  end

  def edit
    @post = Post.find(params[:id])
    # pluckはmapと同じ意味です！！
    @tag_list = @post.tags.pluck(:name).join(',')
  end

  def update
    @post = Post.find(params[:id])
    tag_list = params[:post][:tags][:name].split(',')
    if @post.update(post_params)
      @post.save_tag(tag_list)
      redirect_to post_path(@post.id), notice: '投稿内容を変更しました:)'
    else
      render :edit
    end
  end
  
  def destroy
    post = Post.find(params[:id]) # データ（レコード）を1件取得
    post.destroy # データ（レコード）を削除
    redirect_to '/posts' # 投稿一覧画面へリダイレクト
  end
end
