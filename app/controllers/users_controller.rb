class UsersController < ApplicationController
  before_action :logged_in_user
  
  def admin
    unless is_admin?
      redirect_to login_path, flash: { danger: 'You must be logged in as admin to view this' }
    end
  end
  
end
