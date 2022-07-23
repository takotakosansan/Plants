class Public::CustomersController < ApplicationController
  before_action :authenticate_customer!
  before_action :set_customer, except: [:index]
  def show
    post_ids = @customer.posts_with_reposts.ids
    current_customer_post_ids = @customer.posts.ids
    @posts = Post.where(id: (post_ids | current_customer_post_ids))
  end
  
  def edit
  end
  
  def index
  @customer = Customer.page(params[:page])
  end
  def update
    @posts = @customer.posts  
    if @customer.update(customer_params)
     redirect_to customer_path(current_customer.id)
    else
     render :edit
    end
  end
  
  def favorites
    favorites= Favorite.where(customer_id: @customer.id).pluck(:post_id)
    @favorite_posts = Post.find(favorites)
  end
  
  private

  def customer_params
    params.require(:customer).permit(:name, :profile_image)
  end
  def set_customer
    @customer = Customer.find(params[:id])
  end 
  
end
