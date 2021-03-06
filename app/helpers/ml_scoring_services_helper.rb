module MlScoringServicesHelper
  
  def ldap_test(scoring_service)
    rg_test_cell scoring_service.test_ldap
  end
  
  def ml_scoring_test(scoring_service)
    rg_test_cell scoring_service.test_score
  end
  
  private
  
  def rg_test_cell(success)
    color = success ? '#00FF00' : '#FF0000'
    content_tag 'td', bgcolor: color do
      success ? 'Successful' : 'Unsuccessful'
    end
  end
  
end
