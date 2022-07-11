class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  def self.looks(search, word)
    if search == "perfect_match"
      @customer = Customer.where("first_name LIKE?", "#{word}")
    elsif search == "forward_match"
      @customer = Customer.where("first_name LIKE?","#{word}%")
    elsif search == "backward_match"
      @customer = Customer.where("first_name LIKE?","%#{word}")
    elsif search == "partial_match"
      @customer = Customer.where("first_name LIKE?","%#{word}%")
    else
      @customer = Customer.all
    end
  end
end
