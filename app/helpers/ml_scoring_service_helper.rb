module MlScoringServiceHelper
  
  def ldap_call(scoring_service)
    success = scoring_service.test_ldap
    
    color = success ? '#00FF00' : '#FF0000'
    content_tag 'td', bgcolor: color do
      success ? 'Successful' : 'Unsuccessful'
    end
  end
  
end
