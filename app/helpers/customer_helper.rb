module CustomerHelper
  
  def rg_churn_cell(churn)
    return content_tag :td if churn.nil?
    color = churn ? '#FF0000' : '#00FF00'
    content_tag :td, bgcolor: color do
      churn ? 'Will Churn' : 'No Churn'
    end
  end
  
end
