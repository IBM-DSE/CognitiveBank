module UsersHelper
  
  def is_admin?
    current_user.admin
  end
  
  def is_customer?
    !current_user.admin
  end

  # Returns the current logged-in user (if any).
  def current_customer
    @current_customer ||= current_user.customer
  end

  def rg_table_cell(good, good_text, bad_text = nil)
    return content_tag :td if good.nil?

    color = ''
    color += good ? 'green-cell' : 'red-cell'
    content_tag :td, class: 'colored-cell ' + color do
      (good || bad_text.nil?) ? good_text : bad_text
    end
  end
  
end
