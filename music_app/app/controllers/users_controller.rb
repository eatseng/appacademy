class UsersController < ApplicationController
  before_filter :verify_logged_in, :except => [:create, :new, :request_password_form]

  def new
    render :new
  end

  def create
    @user = User.new(params[:user])
    p "APRAAR"
    p params
    if @user.save
      flash[:notice] = ["#{@user.email} created!!"]
      redirect_to "/users"
    else
      flash[:errors] = @user.errors.full_messages
      render :new
    end
  end

  def index
    @users = User.all
    render :index
  end

  def request_password_form
    render :reset_password
  end

  def receive_request_form
    email = params[:user][:email]
    user = User.find_by_email(email)
    user.set_email_token!
    msg = ResetPasswordMailer.reset_password_email(user)
    msg.deliver!

    render :request_received_confirmation
  end

  def set_new_password
    @user = User.find_by_email_token(params[:email_token])
    if @user
      render :set_new_password
    else
      flash[:errors] = ["cannot find matching email address"]
      render :reset_password
    end
  end

  def record_new_password
    @user = User.find_by_email_token(params[:user][:email_token])
    if @user
      @user.password = params[:user][:password]
      flash[:notice] = ["#{@user.email} password changed!!"]
      @user.save
      render :new
    else
      flash[:errors] = ["cannot find matching email address"]
      render :reset_password
    end
  end


  def show
  end

end
