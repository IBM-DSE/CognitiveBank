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
  
  def show
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
  
  def new
    @customer = Customer.new
    @customer.user = User.new
    @customer.twitter_personality = TwitterPersonality.new
  end
  
  def create
    @customer = Customer.new customer_params.except(:name, :twitter_id)
    @customer.user = User.new customer_params.slice(:name)
    @customer.twitter_personality = TwitterPersonality.new username: customer_params[:twitter_id]
    if @customer.save
      redirect_to customer_path(@customer)
    else
      render :new
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
      if @customer&.update customer_params.except(:name)
        return redirect_to customer_path(@customer) if @customer.user.update customer_params.slice(:name)
      end
      redirect_to login_path, flash: { danger: 'You must be logged in as admin to view this' }
    end
  end
  
  def destroy
    Customer.destroy params[:id]
    redirect_to admin_path
  end
  
  private

  def customer_params
    params.require(:customer).permit(Customer.form_attributes)
  end
  
  def message_params
    params.require(:customer)
  end
  
end
