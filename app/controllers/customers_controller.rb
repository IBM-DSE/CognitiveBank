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
    if params[:id] and is_admin?
      @customer = Customer.find params[:id]
    elsif is_customer?
      @customer = current_customer
    end
      
    if @customer
      @twitter_username = @customer.twitter_personality.username
      
      tweets = Twitter.load_tweets
      personality = @customer.get_personality tweets
      @pi_output = personality.raw_json
      @personality = personality.to_h
      
      @nlu_output = @customer.extract_signals tweets
      @relevant_keywords = NaturalLanguageUnderstanding.relevant_keywords
    else
      redirect_to login_path, flash: { danger: 'You must log in as customer to view your profile' }
    end
  end
  
  def edit
    if is_admin?
      @customer = Customer.find params[:id]
    else
      redirect_to login_path, flash: { danger: 'You must be logged in as admin to view this' }
    end
  end
  
  def update
    if is_admin?
      @customer = Customer.find params[:id]
      if @customer
        if @customer.update customer_params.except(:name)
          if @customer.user.update customer_params.slice(:name)
            redirect_to customer_profile_path
          end
        end
      end
    else
      redirect_to login_path, flash: { danger: 'You must be logged in as admin to view this' }
    end
  end
  
  private

  def customer_params
    params.require(:customer).permit([:name] + Customer.editable_attributes)
  end
  
  def message_params
    params.require(:customer)
  end
  
end
