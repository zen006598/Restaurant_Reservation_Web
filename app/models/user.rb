class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :omniauthable, omniauth_providers: [:google_oauth2]

  enum :role, [:owner, :manager, :staff], default: :owner

  # has_many :user_restaurants
  # has_many :restaurants, -> { distinct }, through: :user_restaurants

  # has_many :subordinates, class_name: "User", foreign_key: "owner_id"
  # belongs_to :owner, class_name: "User", optional: true

  # validates :role, presence: true
  
  def owner?
    role == 'owner'
  end

  def manager?
    role == 'manager'
  end
  
  def staff?
    role == 'staff'
  end
  
  # devise mail job
  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  # google login
  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first

    user ||= User.create(
        name: data['name'] || data['email'].split('@').first,
        email: data['email'],
        password: Devise.friendly_token[0,20]
      )
    user
  end

end
