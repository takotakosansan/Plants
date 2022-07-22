class Public::CustomersController < ApplicationController
  before_action :authenticate_customer!
  def show
    @customer = Customer.find(params[:id])
    @posts = @customer.posts      
  end
  
  def edit
    @customer = Customer.find(params[:id])
  end
  
  def index
  @customer = Customer.page(params[:page])
  end
  def update
    @customer = Customer.find(params[:id])
    @posts = @customer.posts  
    if @customer.update(customer_params)
     redirect_to customer_path(current_customer.id)
    else
     render :edit
    end
  end
  
  def favorites
    @customer = Customer.find(params[:id])
    favorites= Favorite.where(customer_id: @customer.id).pluck(:post_id)
    @favorite_posts = Post.find(favorites)
  end
  
  private

  def customer_params
    params.require(:customer).permit(:name, :profile_image)
  end
  
end
