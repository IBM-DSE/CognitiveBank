class CustomersController < ApplicationController
  def profile
    if logged_in?
      
      # Sort transaction categories
      cc = {}
      TransactionCategory.all.each do |category|
        cc[category.name] = current_customer.transactions.where(transaction_category: category).count
      end
      @sorted_categories = cc.sort_by {|k,v| v}.reverse.to_h
      
      # get personality
      @personality = current_customer.twitter_personality
      
      # Get churn
      @churn = current_customer.get_churn if Rails.env.production?

      current_customer.start_conversation
      
    else
      redirect_to login_path, flash: {danger: 'You must log in to view your profile'}
    end
  end
end
