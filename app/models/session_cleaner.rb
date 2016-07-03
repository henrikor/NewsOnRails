# -*- encoding : utf-8 -*-
class SessionCleaner
  def self.remove_stale_sessions
    CGI::Session::ActiveRecordStore::Session.
      destroy_all( ['updated_on <?', 20.minutes.ago] ) 
  end
end
