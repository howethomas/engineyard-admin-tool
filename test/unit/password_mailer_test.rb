require File.dirname(__FILE__) + '/../test_helper'

class PasswordMailerTest < ActionMailer::TestCase
  tests PasswordMailer
  # 
  # FIXTURES_PATH = File.dirname(__FILE__) + "/../fixtures"
  # 
  # def setup
  #   ActionMailer::Base.delivery_method    = :test
  #   ActionMailer::Base.perform_deliveries = true
  #   ActionMailer::base.deliveries         = []
  #   
  #   @expected = TMail::Mail.new
  #   @expected.set_content_type "text", "plain"
  #   @expected.mime_version = '1.0'
  # end
  # 
  # def read_fixtures(action)
  #   IO.readlines "#{FIXTURES_PATH}/password_mailer/#{action}"
  # end
  # 
end
