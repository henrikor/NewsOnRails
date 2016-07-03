# -*- encoding : utf-8 -*-
class NoruserNotifier < ActionMailer::Base

  def norinitialize
    fil = YAML::load( File.open( "#{Rails.root}/config/nor.yml") )
    domene = fil['DOMENE']
    raise "Can't find domenelink!" if !fil['DOMENELINK']
    return domene
  end
  
  def signup_notification(noruser)
    setup_email(noruser)
    @subject    += 'Aktiver kontoen din!'
    @body[:url]  = "http://#{@domene}/account/activate/#{noruser.activation_code}"
  end
  
  def activation(noruser)
    setup_email(noruser)
    @subject    += 'Kontoen din har blitt aktivert!'
    @body[:url]  = "http://#{@domene}/"
  end


  def forgot_password(noruser)
    setup_email(noruser)
    @subject    += 'Request to change your password'
    @body[:url]  = "http://#{@domene}/account/reset_password/#{noruser.password_reset_code}" 
  end

  def reset_password(noruser)
    setup_email(noruser)
    @subject    += 'Your password has been reset'
  end

  
  protected
  def setup_email(noruser)
    @domene = norinitialize
    @recipients  = "#{noruser.email}"
    @from        = "drift@#{@domene}"
    @subject     = "Velkommen! "
    @sent_on     = Time.now
    @body[:noruser] = noruser
  end
end
