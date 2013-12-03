# -*- encoding : utf-8 -*-
class UserNotifier < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Aktiver kontoen din!'
    @body[:url]  = "http://localhost:3000/account/activate/#{user.activation_code}"
  end
  
  def activation(user)
    setup_email(user)
    @subject    += 'Kontoen din har blitt aktivert!'
    @body[:url]  = "http://localhost:3000/"
  end
  
  protected
  def setup_email(user)
    @recipients  = "#{user.email}"
    @from        = "drift@sos-rasisme.no"
    @subject     = "Velkommen! "
    @sent_on     = Time.now
    @body[:user] = user
  end
end
