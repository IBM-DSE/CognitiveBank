class MlScoringServicesController < ApplicationController
  before_action :admin_user
  
  def new
    @ml_scoring_service = MlScoringService.new
  end
  
  def edit
    @ml_scoring_service = current_ml_service
  end

  def update
    current_ml_service.update ml_scoring_service_params
    redirect_to admin_path
  end

  def create
    MlScoringService.create! ml_scoring_service_params
    redirect_to admin_path
  end
  
  private
  
  def current_ml_service
    MlScoringService.find params[:id]
  end
  
  def ml_scoring_service_params
    params.require(:ml_scoring_service).permit(:name, :hostname, :ldap_port, 
                                               :username, :password, :scoring_port, 
                                               :deployment, :scoring_hostname)
  end
end
