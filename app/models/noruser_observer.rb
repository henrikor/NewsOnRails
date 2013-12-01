# -*- encoding : utf-8 -*-
class NoruserObserver < ActiveRecord::Observer
  def after_create(noruser)
    NoruserNotifier.deliver_signup_notification(noruser)
  end

  def after_save(noruser)
    NoruserNotifier.deliver_activation(noruser) if noruser.recently_activated?
    NoruserNotifier.deliver_forgot_password(noruser) if noruser.recently_forgot_password?
    NoruserNotifier.deliver_reset_password(noruser) if noruser.recently_reset_password?
  end
end
