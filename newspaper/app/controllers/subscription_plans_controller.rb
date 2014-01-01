class SubscriptionPlansController < ApplicationController
  def create
    params[:subscription_plan][:newspaper_id] = params[:newspaper_id]
    @subscription_plan = SubscriptionPlan.new(params[:subscription_plan])
    if @subscription_plan.save
      flash[:notice] = ["Subscription plan created!"]
      redirect_to newspaper_url(Newspaper.find(params[:newspaper_id]))
    else
      flash[:errors] = [@subscription_plan.errors.full_messages]
      redirect_to newspaper_url(Newspaper.find(params[:newspaper_id]))
    end
  end

  def destroy
    @subscription_plan = SubscriptionPlan.find(params[:id])
    @newspaper = @subscription_plan.newspaper
    flash[:notice] = ["Subscription plan deleted"]
    @subscription_plan.destroy
    redirect_to newspaper_url(@newspaper)
  end
end

