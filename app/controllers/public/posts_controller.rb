class Public::PostsController < ApplicationController
  before_action :authenticate_customer!
  def new
      @post = Post.new
      # @post.tags.build
  end

  def create
      # １.&2. データを受け取り新規登録するためのインスタンス作成
      @post = Post.new(post_params)
      @post.customer_id = current_customer.id
      # 受け取った値を,で区切って配列にする
      # tag_list=params[:post][:tags_attributes]["0"][:name].split(',')
      # binding.pry
      tag_list=params[:post][:tags][:name].split(',')
      # binding.pry
      # 3. データをデータベースに保存するためのsaveメソッド実行
      if @post.save
         @post.save_tag(tag_list)
      # 4. トップ画面へリダイレクト
         redirect_to post_path(@post.id)
      else
         render :new
      end
  end

  def index
      if (params[:tag_id])
         @posts = Tag.find(params[:tag_id]).posts.page(params[:page]).per(10)
      else
         @posts = Post.page(params[:page]).per(10)
      end
         @tag_list=Tag.all
  end

  def show
      @post = Post.find(params[:id])
      @post_comment = PostComment.new
      comment = current_customer.post_comments.new
      @error_comment = comment
      @post_tags = @post.tags
      @comment = @post.post_comments.page(params[:page]).per(3)
  end

  def edit
      @post = Post.find(params[:id])
      # pluckはmapと同じ意味です！！
      @tag_list=@post.tags.pluck(:name).join(',')
  end

  def update
      @post = Post.find(params[:id])
      tag_list=params[:post][:tags][:name].split(',')
      if @post.update(post_params)
         @post.save_tag(tag_list)
         redirect_to post_path(@post.id),notice:'投稿内容を変更しました:)'
      else
         render:edit
      end
  end

  def destroy
      post = Post.find(params[:id])  # データ（レコード）を1件取得
      post.destroy  # データ（レコード）を削除
      redirect_to '/posts'  # 投稿一覧画面へリダイレクト
  end

   private
  # ストロングパラメータ
  def post_params
      params.require(:post).permit(:name, :description, :image, :status, :address, tags: [])
  end
end
