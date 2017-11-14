class Message < ApplicationRecord
  belongs_to :customer
  attr_accessor :context
end
