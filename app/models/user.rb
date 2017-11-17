class User < ApplicationRecord
  before_validation :default_values
  
  validates :name, presence: true, length: { maximum: 50 }
  
  before_save :format_email
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  
  has_secure_password
  
  has_one :customer, dependent: :destroy
  
  def default_values
    self.name = 'Customer ' + Customer.maximum(:id).next.to_s if name.blank?
    if email.blank?
      self.email = name.parameterize + '@example.com'
      i = 1
      while User.find_by_email self.email
        self.email = name.parameterize + i.to_s + '@example.com'
      end
    end
    if password.blank?
      self.password ||= 'password'
      self.password_confirmation ||= 'password'
    end
  end
  
  def format_email
    email.downcase!
  end
  
  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
        BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
end
