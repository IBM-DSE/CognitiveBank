class TwitterPersonality < ApplicationRecord
  belongs_to :customer, optional: true
end
