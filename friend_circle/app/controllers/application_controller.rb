class ApplicationController < ActionController::Base
  include SessionsHelper, PostsHelper, LinksHelper
  protect_from_forgery
end
