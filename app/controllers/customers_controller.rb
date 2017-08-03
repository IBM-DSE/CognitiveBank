class CustomersController < ApplicationController
  before_action :logged_in_user
  
  def dashboard
    
    puts ' '
    puts "Customer #{current_customer.name} logged in!"
    
    # Sort transaction categories
    cc = {}
    current_customer.transactions.each do |transaction|
      cc[transaction.category] = 0 unless cc[transaction.category]
      cc[transaction.category] += 1
    end
    @sorted_categories = cc.sort_by { |k, v| v }.reverse.to_h
    
  end
  
  def profile
    if is_customer?
      
      @customer = current_customer
      
      tweets = Twitter.load_tweets
      @personality = @customer.get_personality
      @keywords = @customer.extract_signals tweets

      @customer.update_churn
    else
      redirect_to login_path, flash: { danger: 'You must log in as customer to view your profile' }
    end
  end
  
  private
  
  def message_params
    params.require(:customer)
  end
  
end
