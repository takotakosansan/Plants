class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  has_many :posts, dependent: :destroy       
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  
  has_one_attached :profile_image
         
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
  
  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/sample-author1.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
      profile_image.variant(resize_to_limit: [width, height]).processed
  end
end
