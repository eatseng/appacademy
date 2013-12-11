class ContactsController < ApplicationController

  def index
    user = User.find(params[:user_id])
    render :json => user.all_contacts
  end

  def group_contacts
    user = User.find(params[:user_id])
    render :json => user.contacts_in_groups
  end

  def fav_contacts
    user = User.find(params[:user_id])
    render :json => user.favorite_contacts
  end

  def comments
    user = User.find(params[:user_id])
    render :json => user.comments(params[:contact_id])
  end

  def show
    @contact = Contact.find(params[:id])
    render :json => @contact
  end

  def update
    contact = Contact.find(params[:id])

    if contact.update_attributes(params[:contacts])
      render :json => contact
    else
      render :json => contact.errors, :status => :unprocessable_entity
    end
  end

  def create
    contact = Contact.new(params[:contacts])
    if contact.save
      render :json => contact
    else
      render :json => contact.errors, :status => :unprocessable_entity
    end
  end

  def destroy
    contact = Contact.find(params[:id])
    if contact.destroy
      head :ok
    else
      render :json => { :message => "contact not deleted" }
    end

  end

end
