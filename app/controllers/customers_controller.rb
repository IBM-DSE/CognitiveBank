class CustomersController < ApplicationController
  before_action :logged_in_user, only: [:dashboard, :show]
  before_action :admin_user, except: [:dashboard, :show]
  before_action :store_location, only: [:show]
  
  def dashboard
    
    puts ' '
    puts "Customer #{current_customer.name} logged in!"
    
    # Determine dates
    today    = Date.today
    mon      = today.month
    due_date = Date.new(today.year + mon / 12, mon % 12 + 1, 1)
    
    # Sort transaction categories, calculate date offsets
    cc          = {}
    rel         = Date.strptime('2016-12-31') # original 'today'
    offset_date = {}
    current_customer.transactions.each do |transaction|
      
      # calculate transaction date offset relative to original 'today'
      offset_date[transaction.id] = transaction.date.to_date - rel
      
      cc[transaction.category]    = 0 unless cc[transaction.category]
      cc[transaction.category]    += 1
    end
    
    @transactions      = { due_date: due_date, offset_date: offset_date }
    @sorted_categories = cc.sort_by { |_, v| v }.reverse.to_h
  
  end
  
  def show
    if params[:id] and is_admin?
      @customer   = Customer.find params[:id]
      @modifiable = @customer != Customer.first
    elsif is_customer?
      @customer = current_customer
    end
    
    if @customer
      tweets             = Twitter.load_tweets
      @personality       = @customer.get_personality(tweets).to_h
      @nlu_output        = @customer.extract_signals(tweets)
      @relevant_keywords = NaturalLanguageUnderstanding.relevant_keywords
    else
      redirect_to login_path, flash: { danger: 'You must log in as customer to view your profile' }
    end
  end
  
  def new
    @customer = Customer.new
  end
  
  def create
    @customer = Customer.new customer_params
    if @customer.save
      redirect_to customer_path(@customer)
    else
      render :new
    end
  end
  
  def edit
    if is_admin?
      find_customer_to_modify
    else
      redirect_to login_path, flash: { danger: 'You must be logged in as admin to view this' }
    end
  end
  
  def update
    if find_customer_to_modify
      if @customer&.update(customer_params.except(:name))
        redirect_to customer_path(@customer) if @customer.user.update customer_params.slice(:name)
      else
        render :edit
      end
    end
  end
  
  def destroy
    if find_customer_to_modify
      @customer.destroy
      redirect_to admin_path
    end
  end
  
  private
  
  def customer_params
    params.require(:customer).permit(Customer.form_attributes)
  end
  
  def message_params
    params.require(:customer)
  end
  
  def find_customer_to_modify
    @customer = Customer.find params[:id]
    if @customer == Customer.first
      redirect_back_or admin_path, flash: { warning: "#{@customer.name} cannot be modified." }
      return false
    end
    true
  end

end
