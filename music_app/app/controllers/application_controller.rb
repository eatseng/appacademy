class ApplicationController < ActionController::Base
  include SessionsHelper, PostsHelper
  protect_from_forgery
end
