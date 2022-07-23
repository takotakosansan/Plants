class Public::HomesController < ApplicationController
  def top
    @posts = Post.all.order('created_at DESC').limit(4)
  end
  def new_guest
      customer = Customer.find_or_create_by!(email: 'guest@example.com') do |customer|
      customer.password = SecureRandom.urlsafe_base64
      # customer.confirmed_at = Time.now  # Confirmable を使用している場合は必要
  end
      sign_in customer
      redirect_to root_path, notice: 'ゲストユーザーとしてログインしました。'
  end
end
