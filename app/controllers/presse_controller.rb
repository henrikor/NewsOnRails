# -*- encoding : utf-8 -*-
class PresseController < ApplicationController
  include NorAuthorize
  include NorFelles
  #  include RFC822
  before_filter :nor_logged_in?
  before_filter :klargjor
  before_filter :left_column
  before_filter :nor_authorized?

  def index
    ps = `ps -A |grep nor-massesend-e`
    drift = "drift@#{@domene}"
    unless ps =~ /nor-massesend-e/
      flash[:notice] = "Advarsel: Daemonen som sender e-poster kjorer ikke!"
      Pressesend.send_email(drift, drift, "ALARM: nor-massemail kjorer ikke!", "Start nor-massemail med: /local/etc/init.d/nor-massesend-epost.rb start")
    end
  end


  def bekreft
    @adresser = []
    #    @adresser = extract_emails_to_array(params[:presse]['adresser']).sort
    @adresser = extract_emails_to_array(params[:presse]['adresser'])
    @presse = params[:presse]
    @ptekst = Pressesend.iso_slett_tegn(params[:presse]['melding'])

    @ymlfil = "/var/log/nor/presse/ikkesendt-#{noruser.login}-#{Time.now.to_a}.yml"

    ymldata = params[:presse]
    ymldata['melding'] = Pressesend.iso_slett_tegn(params[:presse]['melding'])
    ymldata["user"] = current_user.login
    ymlfil_ny = File.open(@ymlfil, "w")
    ymlfil_ny << YAML::dump(ymldata)
    
    x = 0
    @feil_email = []
    @adresser2 = []
    @adresser.each{|y|
      x=x+1      
      next unless y =~ /\w/
      if is_email?(y.chomp)
        @adresser2 << y
      else
        @feil_email << y.chomp
      end
    } #params[:presse]['adresser'].length
    @til_antall = x
    @adresser = @adresser2
  end
  

  def sender
    @presse = params[:presse]
    @adresser = params[:presse]['adresser']

    ymlfil = params[:presse]['ymlfil']
    ymlfilsend = ymlfil.gsub(/ikkesendt-/,"pressesend-")
    FileUtils.mv ymlfil, ymlfilsend

    
    #    @adresser.each{|x|
    #      Pressesend.send_email(@presse['fra'], x.chomp, @presse['temafelt'], @presse['melding']) if is_email?(x.chomp)
    #      #      Pressesend.deliver_pressemelding(@presse['fra'], x.chomp, @presse['temafelt'], @presse['melding']) #if is_email?(x.chomp)
    #    }
  end
  
end
