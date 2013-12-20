class User < ActiveRecord::Base
  attr_accessible :email, :password_digest, :session_token, :password
  attr_reader :password
  SEC_IN_DAY = 24*60*60

  has_many :goals
  has_many :cheers

  before_validation :set_session_token
  validates :email, :password_digest, :session_token, :presence => true
  validates :password, :length => {:minimum => 6}, :on => :create

  def set_session_token
    self.session_token ||= SecureRandom.urlsafe_base64
  end

  def reset_session_token!
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

  def completed_goals
    self.goals.where("completed == ?", true)
  end

  def has_cheers?(current_user)
    cheers = Cheer.where("user_id == ?", current_user.id)
    yesterday = Time.zone.now - SEC_IN_DAY
    number_of_cheers = cheers.where("updated_at > ?", yesterday)
    number_of_cheers.length < 5
    end
end
