class Public::PostsController < ApplicationController
  def new
    @post = Post.new
  end
  
  def create
    # １.&2. データを受け取り新規登録するためのインスタンス作成
    @post = Post.new(post_params)
    @post.customer_id = current_customer.id
    # 3. データをデータベースに保存するためのsaveメソッド実行
    if @post.save
    # 4. トップ画面へリダイレクト
    redirect_to posts_path
    else
    render :new
    end
  end
  
  def index
    @posts = params[:tag_id].present? ? Tag.find(params[:tag_id]).posts : Post.all
  end
  
  def show 
    @post = Post.find(params[:id])
    @post_comment = PostComment.new
  end
  
  def edit
  end
  
  def destroy
    post = Post.find(params[:id])  # データ（レコード）を1件取得
    post.destroy  # データ（レコード）を削除
    redirect_to '/posts'  # 投稿一覧画面へリダイレクト  
  end
  
   private
  # ストロングパラメータ
  def post_params
    params.require(:post).permit(:name, :description, :image, tag_ids: [])
  end
end
