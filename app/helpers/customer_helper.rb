module CustomerHelper
  
  def rg_churn_cell(churn)
    return content_tag :td if churn.nil?
    color = churn ? '#FF0000' : '#00FF00'
    content_tag :td, bgcolor: color do
      churn ? 'Will Churn' : 'No Churn'
    end
  end
  
  def num_to_currency(number, options)
    amount = number_with_precision(number, precision: 2)
    if options[:locale] == 'en-IN'
      '₹ ' + number_with_delimiter(amount, delimiter_pattern: /(\d+?)(?=(\d\d)+(\d)(?!\d))/)
    else
      number_to_currency amount, options
    end
  end
  
end
