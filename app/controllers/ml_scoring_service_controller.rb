class MlScoringServiceController < ApplicationController
  def index
    @ml_scoring_services = MlScoringService.all
    @ml_scoring_services.each do |ml_ss|
      puts ml_ss.inspect
    end
    puts @ml_scoring_services.klass.inspect
    puts @ml_scoring_services.klass.columns.inspect
  end
end
