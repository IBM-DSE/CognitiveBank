module CustomersHelper
  
  MAX = 100
  
  MIN_AIRFARE = 1000
  MAX_AIRFARE = 5000
  
  MIN_HOTEL = 300
  MAX_HOTEL = 1000
  
  MIN_DINING = 80
  MAX_DINING = 150
  
  MIN_SAFARI = 800
  MAX_SAFARI = 1200
  
  def rand_dollar(category, locale)
    
    dollars = case category
              when 'Airfare'
                MIN_AIRFARE + rand * (MAX_AIRFARE - MIN_AIRFARE)
              when 'Hotel'
                MIN_HOTEL + rand * (MAX_HOTEL - MIN_HOTEL)
              when 'Dining'
                MIN_DINING + rand * (MAX_DINING - MIN_DINING)
              when 'Safari'
                MIN_SAFARI + rand * (MAX_SAFARI - MIN_SAFARI)
              else
                rand * MAX
              end
    
    num_to_currency dollars.round(2), locale: locale
  end
  
  def num_to_currency(number, options)
    if options[:locale] == 'en-IN'
      number = number_with_precision(number, precision: 2)
      number = number_with_delimiter(number, delimiter_pattern: /(\d+?)(?=(\d\d)+(\d)(?!\d))/)
    end
    number_to_currency number, options
  end
  
  def rg_churn_cell(churn)
    no_churn = !churn unless churn.nil?
    rg_table_cell(no_churn, 'No Churn', 'Will Churn')
  end
  
  def rg_prob_cell(churn_probability)
    return content_tag :td if churn_probability.nil?
    
    churn   = churn_probability > 0.5
    percent = number_to_percentage(churn_probability * 100, precision: 1)
    content_tag :td do
      content_tag :div, class: 'flex' do
        content_tag(:div,
                    ('&nbsp;' + (churn ? percent : '')).html_safe,
                    class: 'red-cell', style: "flex: #{churn_probability}") +
          content_tag(:div,
                      ('&nbsp;' + (churn ? '' : percent)).html_safe,
                      class: 'green-cell', style: "flex: #{1 - churn_probability}")
      end
    end
  end
end
