class CustomersController < ApplicationController
  def profile
    if logged_in?
      
      # Sort transaction categories
      # cc = {}
      # TransactionCategory.all.each do |category|
      #   cc[category.name] = current_customer.transactions.where(transaction_category: category).count
      # end
      # @sorted_categories = cc.sort_by {|k,v| v}.reverse.to_h
      
      # Get churn
      if Rails.env.production?
        @churn = current_customer.get_churn
      else
        puts 'Sending to churn scoring: '+current_customer.churn_attrs.values.to_s
        @churn = current_customer.load_sample_ml_result
      end
      
      # get personality
      @twitter = current_customer.twitter_personality
      
      current_customer.start_conversation
    
    else
      redirect_to login_path, flash: { danger: 'You must log in to view your profile' }
    end
  end
end
