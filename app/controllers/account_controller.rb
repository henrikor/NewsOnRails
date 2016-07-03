# -*- encoding : utf-8 -*-
class AccountController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  # If you want "remember me" functionality, add this before_filter to Application Controller
  # say something nice, you goof!  something sweet.
  def index
    redirect_to(:action => 'login') unless logged_in? # || Noruser.count > 0
#    if logged_in? || Noruser.count > 0
#      flash[:notice] = "loggin: #{session[:noruser]}"
#    else
#      redirect_to(:action => 'signup')
#    end
  end

  def login
    return unless request.post?
    self.current_user = Noruser.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      redirect_back_or_default(:controller => '/account', :action => 'index')
      flash[:notice] = "Du er nå logget inn"
    end
  end

  def signup
    @noruser = Noruser.new(params[:noruser])
    return unless request.post?
    @noruser.save!
    self.current_user = @noruser
    redirect_back_or_default(:controller => '/account', :action => 'index')
    flash[:notice] = "Du har nå registrert konto!"
  rescue ActiveRecord::RecordInvalid
    render :action => 'signup'
  end
  
  def logout
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "Du har logga ut."
    redirect_back_or_default(:controller => '/account', :action => 'index')
  end
  
  def activate
    @user = Noruser.find_by_activation_code(params[:id])
    if @user and @user.activate
      self.current_user = @user
      redirect_back_or_default(:controller => '/account', :action => 'index')
      flash[:notice] = "Kontoen din er nå aktivert." 
    end
  end
  
  # Resett passord ting:
  
  def forgot_password
    return unless request.post?
    if @user = Noruser.find_by_email(params[:email])
      @user.forgot_password
      @user.save
      redirect_back_or_default(:controller => '/account', :action => 'index')
      flash[:notice] = "En passord resett link har blitt sendt til din e-post adresse" 
    else
      flash[:notice] = "Kunne ikke finne noen bruker med den oppgitte e-post adresse" 
    end
  end

  def reset_password
    @user = Noruser.find_by_password_reset_code(params[:id])
    raise if @user.nil?
    return if @user unless params[:password]
    if (params[:password] == params[:password_confirmation])
      
      self.current_user = @user #for the next two lines to work
      current_user.password_confirmation = params[:password_confirmation]
      current_user.password = params[:password]
      @user.reset_password
      flash[:notice] = current_user.save ? "Password reset" : "Password not reset" 
    else
      flash[:notice] = "Passordene stemte ikke med hverandre" 
    end  
    redirect_back_or_default(:controller => '/account', :action => 'index') 
  rescue
    logger.error "Den oppgitte resettkoden er ikke gyldig" 
    flash[:notice] = "Beklager. Den oppgitte resettkoden er ikke gyldig. Sjekk resettkoden og prøv igjen. (Kanskje e-post programmet ditt la inn et linjeskift?"
    redirect_back_or_default(:controller => '/account', :action => 'index')
  end
#  # Resett passord ting, slutt
end
