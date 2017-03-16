ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/reporters'

MiniTest::Reporters.use!
ActiveRecord::Migration.maintain_test_schema!

class ActiveSupport::TestCase
  fixtures :all
  
  # Returns true if a test user is logged in.
  def is_logged_in?
    !session[:user_id].nil?
  end
  
  # Log in as a particular user.
  def log_in_as(user)
    session[:user_id] = user.id
  end
  
  def assert_change(instance, attr)
    old = instance[attr]
    yield
    assert_not_equal old, instance[attr]
  end
  
  def assert_no_change(instance, attr)
    old = instance[attr]
    yield
    assert_equal old, instance[attr]
  end
  
  def set_main_ml_service(instance)
    MlScoringService.set_main ml_scoring_services(instance)
    assert_equal MlScoringService.get_main, ml_scoring_services(instance)
  end
end

class ActionDispatch::IntegrationTest
  # Log in as a particular user.
  def log_in_as(user, password: 'password')
    post login_path, params: { session: { email:    user.email,
                                          password: password } }
  end
end