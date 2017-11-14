module CustomersHelper
  
  MAX=100
  
  MIN_AIRFARE=1000
  MAX_AIRFARE=5000
  
  MIN_HOTEL=300
  MAX_HOTEL=1000
  
  MIN_DINING=80
  MAX_DINING=150

  MIN_SAFARI=800
  MAX_SAFARI=1200
  
  def rand_dollar(category, locale)
    
    dollars = case category
                when 'Airfare'
                  MIN_AIRFARE + rand * (MAX_AIRFARE-MIN_AIRFARE)
                when 'Hotel'
                  MIN_HOTEL + rand * (MAX_HOTEL-MIN_HOTEL)
                when 'Dining'
                  MIN_DINING + rand * (MAX_DINING-MIN_DINING)
                when 'Safari'
                  MIN_SAFARI + rand * (MAX_SAFARI-MIN_SAFARI)
                else
                  rand * MAX
              end
    
    number_to_currency dollars.round(2), locale: locale
  end

end