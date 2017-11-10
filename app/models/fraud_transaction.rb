class FraudTransaction < ApplicationRecord

  FRAUD_HOSTNAME      = ENV['FRAUD_HOSTNAME']
  FRAUD_USERNAME      = ENV['FRAUD_USERNAME']
  FRAUD_PASSWORD      = ENV['FRAUD_PASSWORD']
  FRAUD_DEPLOYMENT_ID = ENV['FRAUD_DEPLOYMENT_ID']
  
  def detect_fraud

    # Create the service object
    ml_service = IBM::ML::Local.new(FRAUD_HOSTNAME, FRAUD_USERNAME, FRAUD_PASSWORD)
    p ml_service

    # Get a score for the given deployment and record
    record = self.attributes.except('id').map { |k, v| [k.titleize, v] }.to_h
    record['Amount'] = record['Amount'].to_f
    score = ml_service.score(FRAUD_DEPLOYMENT_ID, record)
    fields = score['fields']
    values = score['records'][0]
    fields.each_with_index.map { |f,i| [f, values[i]] }.to_h
  end
end
