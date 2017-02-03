class CustomersController < ApplicationController
  def profile
    if logged_in?
  
      @churn = current_customer.get_churn if Rails.env.production?
      
      cc = {}
      TransactionCategory.all.each do |category|
        cc[category.name] = current_customer.transactions.where(transaction_category: category).count
      end
      @sorted_categories = cc.sort_by {|k,v| v}.reverse.to_h
    else
      redirect_to login_path, flash: {danger: 'You must log in to view your profile'}
    end
  end
end
