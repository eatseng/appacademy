class NewspapersController < ApplicationController
  before_filter :verify_user_logged_in?

  def index
    @newspapers = Newspaper.all
  end

  def new
    @newspaper = Newspaper.new
  end

  def show
    @newspaper = Newspaper.find(params[:id])
  end

  def create
    @newspaper = Newspaper.new(params[:newspaper])
    filled_plans = params[:subscription_plan].values.select {|plan| plan['price']!=""}
    @newspaper.subscription_plans.new(filled_plans)
    if @newspaper.save
      flash[:notice] = ["#{@newspaper.title} created!"]
      redirect_to newspapers_url
    else
      flash.now[:errors] = [@newspaper.errors.full_messages]
      @subsciption_plan = SubscriptionPlan.new(params[:subsciption_plan])
      render :new
    end
  end

  def edit
    @newspaper = Newspaper.find(params[:id])
    @subscription_plans = @newspaper.subscription_plans
  end

  def update
    @newspaper = Newspaper.find(params[:id])
    params['newspaper']['subscription_plans_attributes'] = params[:subscription_plans_attributes]
    if @newspaper.update_attributes(params[:newspaper])
      flash[:notice] = ["#{@newspaper.title} updated!"]
      redirect_to newspapers_url
    else
      flash.now[:errors] = [@newspaper.errors.full_messages]
      @subscription_plan = @newspaper.subscription_plans
      render :edit
    end
  end

  def destroy
    @newspaper = Newspaper.find(params[:id])
    flash[:notice] = ["#{@newspaper.title} deleted!"]
    @newspaper.destroy
    redirect_to newspapers_url
  end
end
