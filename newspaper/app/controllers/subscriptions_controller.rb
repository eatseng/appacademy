class SubscriptionsController < ApplicationController

  def destroy
    @subscription = Subscription.find(params[:id])
    flash[:notice] = ["Subscription deleted!"]
    @subscription.destroy
    redirect_to sub_url
  end
end
