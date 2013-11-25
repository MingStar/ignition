class User < ActiveRecord::Base
  has_many :pledges
  has_many :events
  has_many :comments
  has_many :projects, :through => :pledges
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name
  # attr_accessible :title, :body

  devise :omniauthable, :omniauth_providers => [:google_oauth2]

  def image_url
    Gravatar.new(email).image_url
  end
  
  def username
    name == "" ? email : name
  end


  def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
    data = access_token.info
    user = User.where(:email => data["email"]).first

    unless user
      user = User.create(name: data["name"],
                         email: data["email"],
                         password: Devise.friendly_token[0,20]
      )
    end
    user
  end
end
