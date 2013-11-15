class GeneralMailer < ActionMailer::Base
  default from: 'siruguri@gmail.com', subject: 'Test email from Baseline App'
  
  def example_email(to_address)
    mail to: to_address
  end
end
