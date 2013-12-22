class SubsController < ApplicationController
  before_filter :user_logged_in?
  
  def index
    @subs = Sub.all
  end

  def new
    @sub = Sub.new
    render :new
  end

  def create
    @sub = Sub.new(params[:sub])
    mod_params = params[:link].select {|param| param['title']!=""}
    @sub.links.new(mod_params)
    if @sub.save
      flash[:notice] = ["#{@sub.name} created!"]
      redirect_to subs_url
    else
      flash.now[:errors] = @sub.errors.full_messages
      render :new
    end
  end

  def show
    @sub = Sub.find(params[:id])
    render :show
  end

  def destroy
    @sub = Sub.find(params[:id])
    flash[:notice] = ["#{@sub.name} deleted!"]
    @sub.destroy
    redirect_to subs_url
  end
end
