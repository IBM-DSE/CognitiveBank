class Message < ApplicationRecord
  belongs_to :customer
  validates :customer_id, presence: true
  validates :content, presence: true
  
  attr_accessor :context
  
  private
  
  def self.update_customer(results, customer)
    # update user context
    customer.context = results[:context]

    # print intents and entities
    if results[:intents][0] and results[:intents][0][:confidence] > 0.9 or results[:entities][0]
      puts ' '
      puts 'Watson NLP results:'
    end
    if results[:intents][0] and results[:intents][0][:confidence] > 0.9
      puts "Intent: #{results[:intents][0][:intent].upcase}"
    end
    if results[:entities][0]
      range = results[:entities][0][:location]
      puts "Entities: #{results[:input][:text][range[0]..range[1]].upcase}"
    end

    # store watson messages
    results[:output][:text].each do |line|
      msg = customer.messages.build content: line, watson_response: true
      puts ' '
      puts "Watson response: \"#{msg.content}\""
    end
    
    # save the customer data
    customer.save
    
    if results[:output][:action]
      action = results[:output][:action]
      puts ' '
      puts 'Watson Conversation Action Signal: '+action
      
      if action == 'check_churn'
        send_to_watson_conversation('churn', customer) if customer.will_churn?
      end
    end
    
  rescue Exception => e
    puts e
  end

end
