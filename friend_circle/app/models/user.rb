class User < ActiveRecord::Base
  attr_accessible :email, :password, :session_token, :email_token
  attr_reader :password
  before_validation :set_session_token

  has_many(
  :circles,
  :class_name => "FriendCircle",
  :foreign_key => :user_id,
  :primary_key => :id
  )

  has_many(
  :posts,
  :class_name => "Post",
  :foreign_key => :user_id,
  :primary_key => :id
  )

  has_many :connected_friends, :through => :circles, :source => :members
  has_many :feed_posts, :through => :circles, :source => :posts

  validates :email, :presence => true, :uniqueness => true
  validates :password_digest, :session_token, :presence => true
  validates :password, :presence => true, :length => {:minimum => 6}, :on => :create

  def set_session_token
    self.session_token ||= SecureRandom.urlsafe_base64
  end

  def set_email_token!
    self.email_token ||= SecureRandom.urlsafe_base64
    self.save
  end

  def reset_session_token!
    p "reset session token self val"
    p self
    set_session_token
    self.save!
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def self.find_by_credentials(email, password)
    user = User.find_by_email(email)
    return nil if user.nil?
    return user if user.is_password?(password)
    nil
  end
end
