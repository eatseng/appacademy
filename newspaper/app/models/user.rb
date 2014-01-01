class User < ActiveRecord::Base
  attr_accessible :email, :password_digest, :session_token, :password
  attr_reader :password

  has_many :subscriptions, :dependent => :destroy

  before_validation :set_session_token
  validates :email, :password_digest, :session_token, :presence => true
  validates :password, :length => {:minimum => 6}

  def set_session_token
    self.session_token ||= SecureRandom.urlsafe_base64
  end

  def reset_session_token
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

  def self.find_by_credential(params)
    user = User.find_by_email(params[:user][:email])
    return nil if user.nil?
    return user if user.is_password?(params[:user][:password])
    nil
  end
end
