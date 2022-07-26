class Public::RelationshipsController < ApplicationController
  before_action :ensure_guest_customer, only: [:create, :destroy]
  before_action :authenticate_customer!
  # フォローするとき
  def create
      current_customer.follow(params[:customer_id])
      redirect_to request.referer
  end
  # フォロー外すとき
  def destroy
      current_customer.unfollow(params[:customer_id])
      redirect_to request.referer  
  end
  # フォロー一覧
  def followings
      customer = Customer.find(params[:customer_id])
      @customers = customer.followings
  end
  # フォロワー一覧
  def followers
      customer = Customer.find(params[:customer_id])
      @customers = customer.followers
  end
  
  private
  def ensure_guest_customer
      @customer = current_customer
      if @customer.name == "guest"
         redirect_to customer_path(current_customer) , notice: 'ゲストユーザーはフォロー機能を利用できません。'
      end
  end  
end
