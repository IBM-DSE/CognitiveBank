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

    # ML_Scoring.new current_customer
    
    current_customer.start_conversation
  end
  
  def profile
    if is_customer?
      
      # Get churn
      @churn_result = ML_Scoring.new current_customer
      
      puts ' '
      puts "Fetching Personality Insights for #{current_customer.name}..."
      @twitter = current_customer.twitter_personality
      puts 'Customer Personality:'
      @twitter.attributes.slice('personality', 'values', 'needs').each do |k,v|
        puts "  #{k.humanize}: #{v}"
      end
    else
      redirect_to login_path, flash: { danger: 'You must log in as customer to view your profile' }
    end
  end
  
  def clear_messages
    @customer = Customer.find params[:id]
    @customer.messages.destroy_all
    @customer.context = nil
    unless @customer.save
      flash.now[:danger] = "There was an error when deleting the messages for customer #{params[:id]}"
    end
    redirect_to admin_path
  end
  
  private
  
  def message_params
    params.require(:customer)
  end
end
