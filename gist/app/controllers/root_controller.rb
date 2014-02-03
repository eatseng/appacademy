class RootController < ApplicationController
  def root
    respond_to do |format|
      format.html { render :root }
    end
  end
end
