class Public::PostsController < ApplicationController
  def new
    @post = Post.new
  end
  
  def create
    # １.&2. データを受け取り新規登録するためのインスタンス作成
    post = Post.new(post_params)
    # 3. データをデータベースに保存するためのsaveメソッド実行
    post.save
    # 4. トップ画面へリダイレクト
    redirect_to '/'
  end
  
  def index
    @posts = Post.all
  end
  
  def show 
  end
  
  def edit
  end
  
   private
  # ストロングパラメータ
  def post_params
    params.require(:post).permit(:name, :description )
  end
end
