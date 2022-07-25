class Public::CustomersController < ApplicationController
  before_action :authenticate_customer!
  before_action :ensure_guest_customer, only: [:edit]
  before_action :set_customer, except: [:index]
  def show
    post_ids = @customer.posts_with_reposts.ids
    current_customer_post_ids = @customer.posts.ids
    @posts = Post.where(id: (post_ids | current_customer_post_ids)).page(params[:page]).per(4)
  end
  
  def edit
  end
  
  def index
  @customer = Customer.page(params[:page])
  end
  def update
    @posts = @customer.posts  
    if @customer.update(customer_params)
     redirect_to customer_path(current_customer.id),notice:'ユーザー情報を変更しました:)'
    else
     render :edit
    end
  end
  
  def favorites
    favorites= Favorite.where(customer_id: @customer.id).pluck(:post_id)
    @favorite_posts = Post.find(favorites)
  end
  
  def bye
    @customers = Customer.find(params[:id])
  end
  
  def adios
    @customer = current_customer
    @customer.update(status: false)
    reset_session
    redirect_to root_path
  end
  
  private

  def customer_params
    params.require(:customer).permit(:name, :profile_image)
  end
  def set_customer
    @customer = Customer.find(params[:id])
  end 
  
  def ensure_guest_customer
    @customer = Customer.find(params[:id])
    if @customer.name == "guest"
      redirect_to customer_path(current_customer) , notice: 'ゲストユーザーはプロフィール編集画面へ遷移できません。'
    end
  end  
  end
