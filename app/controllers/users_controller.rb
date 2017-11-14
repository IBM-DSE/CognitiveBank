class UsersController < ApplicationController
  before_action :admin_user
  
  def admin
    @customers = Customer.all
    @ml_scoring_services = MlScoringService.all
  end
  
end
