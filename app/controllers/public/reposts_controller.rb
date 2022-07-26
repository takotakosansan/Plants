class Public::RepostsController < ApplicationController
  before_action :set_post
  before_action :ensure_guest_customer, only: [:create]

  def create  # リポストボタンを押下すると、押したユーザと押した投稿のIDよりrepostsテーブルに登録する
    if Repost.find_by(customer_id: current_customer.id, post_id: @post.id)
      redirect_to posts_path(@post), alert: '既にリポスト済みです'
    else
      @repost = Repost.create(customer_id: current_customer.id, post_id: @post.id)
    end
  end

  def destroy # 既にリポストした投稿のリポストボタンを再度押下すると、リポストを取り消す（=テーブルからデータを削除する）
    @repost = current_customer.reposts.find_by(post_id: @post.id)
    if @repost.present?
      @repost.destroy
    else
      redirect_to posts_path(@post), alert: '既にリポストを取り消し済みです'
    end
  end

  private

  def set_post  # リポストボタンを押した投稿を特定する
    @post = Post.find(params[:post_id])
    if @post.nil?
      redirect_to root_path, alert: '該当の投稿が見つかりません'
    end
  end

  def ensure_guest_customer
    @customer = current_customer
    if @customer.name == "guest"
      redirect_to customer_path(current_customer), notice: 'ゲストユーザーはリポスト機能を利用できません。'
    end
  end
end
