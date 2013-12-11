class ContactSharesController < ApplicationController

  def index
    @contact_shares = ContactShare.all
    render :json => @contact_shares
  end

  def create
    contact_share = ContactShare.new(params[:contact_shares])
    if contact_share.save
      render :json => contact_share
    else
      render :json => contact_share.errors, :status => :unprocessable_entity
    end
  end

  def destroy
    contact_share = ContactShare.find(params[:id])
    contact_share.destroy
    render :json => { :message => "contact share deleted" }
  end

end
