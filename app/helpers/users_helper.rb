module UsersHelper
  
  def is_admin?
    current_user.admin
  end
  
  def is_customer?
    current_user.customer
  end

  # Returns the current logged-in user (if any).
  def current_customer
    @current_customer ||= current_user.customer
  end
  
end
