# frozen_string_literal: true

# Interface to Watson Natural Language Understanding service
class NaturalLanguageUnderstanding
  def self.extract_keywords(text)
    # call WPI with twitter data as input

    payload = { text: text, features: KEYWORD_FEATURES }.to_json
    response = NLU_RESOURCE.post(payload, content_type: :json)
    JSON.parse(response)
  rescue => e
    STDERR.puts "Watson Natural Language Understanding ERROR: #{e}"
    Util.handle_nlu_error
  end
  
  def self.relevant_keywords
    [
      'credit card',
      'foreign exchange fees',
      'atm fee'
    ]
  end

  private

  # Watson Personality Insights URL and credentials
  NLU_URL      = 'https://gateway.watsonplatform.net/natural-language-understanding/api/v1/analyze?version=2017-02-27'
  if ENV['VCAP_SERVICES']
    convo_creds = CF::App::Credentials.find_by_service_label('natural-language-understanding')
    if convo_creds
      NLU_USERNAME = convo_creds['username']
      NLU_PASSWORD = convo_creds['password']
    end
  else
    NLU_USERNAME = ENV['NLU_USERNAME']
    NLU_PASSWORD = ENV['NLU_PASSWORD']
  end

  # Watson Personality Insights Resource for making REST calls
  NLU_RESOURCE = RestClient::Resource.new NLU_URL, user: NLU_USERNAME, password: NLU_PASSWORD if NLU_USERNAME && NLU_PASSWORD

  KEYWORD_FEATURES = {
    keywords: {
      sentiment: true,
      limit: 10
    }
  }.freeze

  ENTITY_FEATURES = {
    entities:  {
      emotion: true,
      sentiment: true,
      limit: 2
    }
  }.freeze
end
