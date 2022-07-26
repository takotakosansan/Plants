class SearchesController < ApplicationController
  before_action :authenticate_customer!

  def search
    @range = params[:range]

    if @range == "User"
      @customers = Customer.looks(params[:search], params[:word])
      redirect
    else
      @posts = Post.looks(params[:search], params[:word])
    end
  end
end
