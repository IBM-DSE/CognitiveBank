class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper, UsersHelper
  
  private
  
  # Confirms a logged-in user.
  def logged_in_user
    unless logged_in?
      login_page
    end
  end

  def admin_user
    unless logged_in? && is_admin?
      login_page
    end
  end
  
  def login_page
    store_location
    flash[:danger] = 'Please log in.'
    redirect_to login_url
  end
  
end