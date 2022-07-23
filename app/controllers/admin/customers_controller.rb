class Admin::CustomersController < ApplicationController
  def index
    @customers = Customer.all
  end

  def show
    @customer = Customer.find(params[:id])
  end

  def edit
    @customer = Customer.find(params[:id])
  end

  def update
    @customer=Customer.find(params[:id])
    @customer.update(customer_params)
    if @customer.update(customer_params)
     redirect_to admin_customer_path(@customer)
    else
     render :edit
    end
  end

  private
  def customer_params
    params.require(:customer).permit(:name, :email, :status )
  end
end
