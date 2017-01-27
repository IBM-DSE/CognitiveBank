class UsersController < ApplicationController
  def profile
    if logged_in?
      cc = {}
      for category in TransactionCategory.all
        cc[category.category] = current_user.transactions.where(category: category.category).count
      end
      @sorted_categories = cc.sort_by {|k,v| v}.reverse.to_h
    else
      redirect_to login_path, flash: {danger: 'You must log in to view your profile'}
    end
  end
end
