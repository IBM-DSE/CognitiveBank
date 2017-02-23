class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      current_customer.clear_conversation if is_customer?
      redirect_to user.admin ? admin_path : dashboard_path
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end
  
  def destroy
    current_customer.clear_conversation if is_customer?
    log_out
    redirect_to root_path
  end
end
