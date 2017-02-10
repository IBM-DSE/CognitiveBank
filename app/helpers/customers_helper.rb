module CustomersHelper
  
  MAX=1000
  
  def rand_dollar
    '$ '+(rand * MAX).round(2).to_s
  end
  
end
