class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper, UsersHelper
  
  private
  
  # Confirms a logged-in user.
  def logged_in_user
    login_page unless logged_in?
  end

  def admin_user
    login_page unless logged_in? && is_admin?
  end
  
  def login_page
    store_location
    flash[:danger] = 'Please log in.'
    redirect_to login_url
  end
  
end