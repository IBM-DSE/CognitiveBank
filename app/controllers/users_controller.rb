class UsersController < ApplicationController
  before_action :admin_user
  before_action :store_location
  
  def admin
    @customers = Customer.all
    @ml_scoring_services = MlScoringService.all
  end
  
end
