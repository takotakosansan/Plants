class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  has_many :posts, dependent: :destroy       
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  
  # フォローをした、されたの関係
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy

  # 一覧画面で使う
  has_many :followings, through: :relationships, source: :followed
  has_many :followers, through: :reverse_of_relationships, source: :follower
  
  has_many :reposts, dependent: :destroy
  has_one_attached :profile_image
  
  validates :email, presence: true
  validates :password, presence: true
  validates :name, presence: true,length: { maximum: 8 } 
         
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
    file_path = Rails.root.join('app/assets/images/no_image.jpg')
    profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
   end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end
  
  def reposted?(post_id)
    self.reposts.where(post_id: post_id).exists?
  end
  
  def posts_with_reposts
  relation = Post.joins("LEFT OUTER JOIN reposts ON posts.id = reposts.post_id AND reposts.customer_id = #{self.id}")
                 .select("posts.*, reposts.customer_id, (SELECT name FROM customers WHERE id = reposts.customer_id) AS repost_customer_name")
  relation.where(customer_id: self.id)
          .or(relation.where("reposts.customer_id = ?", self.id))
          .with_attached_image
          .preload(:customer, :post_comments, :favorites, :reposts)
          .order(Arel.sql("CASE WHEN reposts.created_at IS NULL THEN posts.created_at ELSE reposts.created_at END"))
  end
    
  # フォローしたときの処理
  def follow(customer_id)
    relationships.create(followed_id: customer_id)
  end
  # フォローを外すときの処理
  def unfollow(customer_id)
    relationships.find_by(followed_id: customer_id).destroy
  end
  # フォローしているか判定
  def following?(customer)
    followings.include?(customer)
  end
  
  def active_for_authentication?
    super && (status == true)
  end
end
