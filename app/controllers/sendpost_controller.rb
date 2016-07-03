# -*- encoding : utf-8 -*-
class SendpostController < ApplicationController
  include ArticlesHelper #ClothSyntax
  include ApplicationHelper #ClothSyntax
  require "fileutils"
  require 'zip/zip'

  #    before_filter :nor_authorized?
  before_filter :nor_authorized?, :except => [:index]
  #  before_filter :nor_authorized?, :only => [:admin]

  def index
    exit 1 if params[:komment] && params[:komment] =~ /\w/
    exit 0 if params[:reklame] && params[:reklame] =~ /\w/
    brukerip = request.env['HTTP_REFERER']
    @alarm = nil
    @alarm = "Skjemaet er laget feil:epostg (e-post gruppe) mangler" unless params.include?(:epostg)

    logger.debug "MailAlarm--: #{@alarm}" unless @alarm == nil
    @epostg = params[:epostg]

    if params[:subject]
      @subject = params[:subject]
    else
      @subject = "Webskjema: #{params[:epostg]}"
    end

    ymldata = params
    ymllog = File.open("#{Rails.root}/log/#{@epostg}.yml", "w")
    ymllog << YAML::dump(ymldata)

    begin
      lagreyml(@epostg, "log")
    rescue
      @arkivfil = "Finner ikke @arkivfil variabelen." unless defined?(@arkivfil)
      @alarm = "Klarte ikke lagre: #{@arkivfil} Mail sendt til drift@#{@domene}."
      logger.debug "MailAlarm--2: #{@alarm}" unless @alarm == nil

      Pressesend.send_email("drift@#{@domene}", "drift@#{@domene}", "FEIL: Klarte ikke lagre yml fil fra webskjema", "Klarte ikke lage Yml arkivfil: #{@arkivfil}. Skjema sendt fra: #{brukerip}")
    end

    begin
      @ymldata = YAML::load( File.open( "#{Rails.root}/config/epostgrupper.yml") )
    rescue
      @alarm = "Alvorlig feil i epostgrupper.yml. Yml arkivfil av webskjemaet ligger her: #{@arkivfil} Rett opp i /sendpost/admin og sjekk arkivfila. Mail sendt til drift@#{@domene}"
      logger.debug "MailAlarm--3: #{@alarm}" unless @alarm == nil

      Pressesend.send_email("drift@#{@domene}", "drift@#{@domene}", "FEIL: feil i epostgrupper.yml fila!", "Alvorlig feil i epostgrupper.yml. Yml arkivfil av webskjemaet ligger her: #{@arkivfil} Rett opp i /sendpost/admin og sjekk arkivfila")
    end

    #    @ymldata = YAML::load( File.open( "#{Rails.root}/config/epostgrupper.yml") )
    #    @alarm = "Epostgruppa #{@epostg} finnnes ikke i epostgrupper.yml" unless defined?(ymldata[@epostg])
    if defined?(@ymldata)
      @alarm = "Epostgruppa #{@epostg} finnnes ikke i epostgrupper.yml" unless @ymldata.include?(@epostg)
      logger.debug "MailAlarm--4: #{@alarm}" unless @alarm == nil

    end

    unless @alarm == nil
      flash[:error] = norsk2html("<h1>Dette skjemaet er feil laget. Prøv seinere</h1><p>#{@alarm}</p>")
      logger.debug "MailAlarm2: #{@alarm}"

      redirect_to :back
    else
      @sentrale_arg = Hash.new
      @rest_arg = Hash.new
      @mangler_arg = Hash.new
      @skjul_arg = ["controller", "submit", "subject", "epostg", "action"]

      nyhash = Hash.new
      params.each{|key, val|
        @mangler_arg[key] = val if key =~ /§/ and not val =~ /\w/
        nykey = key.gsub(/§/,"")
        nyhash[nykey] = Pressesend.iso_slett_tegn(val) unless val.is_a? Hash
        #        nyhash[nykey] = "TEST"
      }
      nyhash.each{|key, val|
        @mangler_arg[key] = val if key =~ /§/ and not val =~ /\w/
        #        @sentrale_arg[key] = val if key =~ /gruppe/i
        @sentrale_arg["fornavn"] = val if key.downcase == "fornavn"
        @sentrale_arg["etternavn"] = val if key.downcase == "etternavn"
        @sentrale_arg["navn"] = val if key.downcase == "navn"
        @sentrale_arg["adresse"] = val if key.downcase == "adresse"
        @sentrale_arg["postnr"] = val if key.downcase == "postnr"
        @sentrale_arg["sted"] = val if key.downcase == "sted"
        @sentrale_arg["tlf_p"] = val if key.downcase == "telefon_p"
        @sentrale_arg["tlf_j"] = val if key.downcase == "telefon_j"
        @sentrale_arg["tlf_j"] = val if key.downcase == "tlf_j"
        @sentrale_arg["tlf_p"] = val if key.downcase == "tlf_p"
        @sentrale_arg["tlf"] = val if key.downcase == "tlf"
        @sentrale_arg["mob"] = val if key.downcase == "mob"
        @sentrale_arg["e-post"] = val if key.downcase == "e-mail" || key.downcase == "email" || key.downcase == "e-post" || key.downcase == "epost"
        @fraepost = val if key.downcase == /e-?post/ and not key =~ /epostg/
        @sentrale_arg["fdato"] = val if key.downcase == /fdato/i
        @sentrale_arg["fdato"] = val if key.downcase == /fødselsdato/i
        @sentrale_arg["fdato"] = val if key.downcase =~ /fodselsdato/i
        @sentrale_arg["lokallag?"] = val if key.downcase == "lokallag?"
        @sentrale_arg["fylke"] = val if key.downcase == "fylke"
        @sentrale_arg["beskjed"] = val if key.downcase == "beskjed"
      }

      if defined?(@sentrale_arg["e-post"])
        @fraepost = @sentrale_arg["e-post"]
        @fraepost = "fra-ingen@epost.no" unless @fraepost =~ /\w/
      else
        @fraepost = "fra-ingen@epost.no"
      end
      
      nyhash.each{|key, val|
        @rest_arg[key] = val if val =~ /\w/ and not @sentrale_arg.has_value?(val) and not @skjul_arg.include?(key)
      }

      tomliste = "<ul>"
      @mangler_arg.each{|key, val|
        tomliste = tomliste + "<li> #{key.gsub(/§/,"")}</li>"
        @rest_arg[key] = val unless @sentrale_arg.has_value?(val)
      }
      tomliste = tomliste + "</ul>"

      unless @mangler_arg.empty?
        flash[:error] = norsk2html("<h1>Ups... du glemte å fylle ut følgende felter:</h1>#{tomliste}")
      else
        #       Pressesend.send_email("henrik@sos-rasisme.no", "henrik@sos-rasisme.no", "test2", "TEST") #if is_email?(x.chomp)

        formdata = ""
        formdata = "#{@sentrale_arg["fornavn"]} #{@sentrale_arg["etternavn"]}\n" if defined?(@sentrale_arg["fornavn"]) && defined?(@sentrale_arg["etternavn"])
        formdata = "#{formdata}#{@sentrale_arg["navn"]}" if defined?(@sentrale_arg["navn"])
        formdata = "#{formdata}#{@sentrale_arg["adresse"]}\n" if defined?(@sentrale_arg["adresse"])
        formdata = "#{formdata}#{@sentrale_arg["postnr"]} #{@sentrale_arg["sted"]}\n\n"  if defined?(@sentrale_arg["postnr"])
        formdata = "#{formdata}tlf privat: " + @sentrale_arg["tlf_p"] + "\n" if @sentrale_arg["tlf_p"] != nil
        formdata = "#{formdata}tlf jobb: " + @sentrale_arg["tlf_j"] + "\n" if @sentrale_arg["tlf_j"] != nil
        formdata = "#{formdata}mob: " + @sentrale_arg["mob"] + "\n" if @sentrale_arg["mob"] != nil
        formdata = "#{formdata}tlf: " + @sentrale_arg["tlf"] + "\n" if @sentrale_arg["tlf"] != nil
        formdata = "#{formdata}f.dato: " + @sentrale_arg["fdato"] + "\n" if @sentrale_arg["fdato"]  != nil
        formdata = "#{formdata}fylke: " + @sentrale_arg["fylke"] + "\n\n" if @sentrale_arg["fylke"]  != nil
        formdata = "#{formdata}lokallag?: " + @sentrale_arg["lokallag?"] + "\n\n" if @sentrale_arg["lokallag?"]  != nil
        formdata = "#{formdata}Beskjed: \n" + @sentrale_arg["beskjed"] + "\n" if @sentrale_arg["beskjed"]  != nil

        # Legg inn "komment" felt, som dropper alt, om dette har noe i seg.


        #        @sentrale_arg.each{|key, val|
        #          formdata = formdata + "#{val}\n"
        #        }
        formdata = formdata + "\n\n"
        @rest_arg.each{|key, val|
          @rest_arg[key] = ": #{val}"
        }
        @rest_arg = @rest_arg.sort
        #        @rest_arg.each{|key, val|
        #          formdata = formdata + "#{key}: #{val}\n"
        @rest_arg.each{|key|
          formdata = formdata + "#{key}\n"
        }
        formdata = formdata + "\n\n"
        formdata = formdata + "Skjema url: #{brukerip}\n"
        formdata = formdata + "Avsenders IP: #{request.env['REMOTE_ADDR']}\n"


        postheader = ""
        request.env.each{|x,y|
          postheader = postheader + "#{x}: #{y}" + "\n"
        }
        #        formdata = formdata + "\n\nHTTP sladder: \n\n" + postheader

        #        @sentrale_arg.each{|key, val|
        #          formdata = formdata + "#{key}: #{val}\n"
        #        }

        #        ymldata = "Subject: #{@subject} \n" + formdata
        #        ymllog = File.open("#{Rails.root}/log/#{@epostg}.yml", "w")
        #        ymllog << YAML::dump(ymldata)
        #        lagreyml(@epostg, "log")

        @formdata = formdata

        if defined?(params[:kvittering]) || defined?(params[:avsender])
          Pressesend.send_email(@fraepost, @fraepost, slettnorske(@subject), to_iso(formdata)) if is_email?(@fraepost)
        end
        
#        begin
          @ymldata[@epostg].each{|x|
            Pressesend.send_email(@fraepost, x, slettnorske(@subject), formdata) if is_email?(x)
#            Pressesend.send_email("henrik@tjen-folket.no", x, slettnorske(@subject), formdata) if is_email?(x)
                                  #from, to, subject, message
          }
 #       rescue
        #   @alarm = "Klarte ikke sende skjemaet. Mail sendt til drift@#{@domene}"
        #   flash[:error] = norsk2html("<h1>Dette skjemaet er feil laget. Prøv seinere</h1><p>#{@alarm}</p>")
        #   logger.debug "MailAlarm 186--: #{@alarm}" unless @alarm == nil

        #   Pressesend.send_email("drift@#{@domene}", "drift@#{@domene}", "FEIL: Klarte ikke sende webskjema", "Klarte ikke sende webskjema til alle mottakere i epostgruppa. Sjekke epostgruppe på /sendpost/admin Yml arkivfil: #{@arkivfil}")
        #   redirect_to :back
        # end
        # #        Rails.logger.error("\n NOR-- Prover aa kjore sfp  \n")
        Kurs.sfp(params) if @epostg == "populus" # Innmelding av sfp tiltak

      end
    end
  end
  def admin
    unless File.exists?("#{Rails.root}/config/epostgrupper.yml")
      fil = File.open("#{Rails.root}/config/epostgrupper.yml", "w")
      startyml = %{# Eksempel på epostgrupper: \ntest: [ henrik@domene.no, henrik.ormasen@domene.no ]\ntestgruppe2: [ henrik@domene.no ]}
      fil.syswrite(startyml)
    end
    @sendpost = Hash.new
    @sendpost["ymldata"] = IO.read("#{Rails.root}/config/epostgrupper.yml")
  end

  def lagre
    #    fil.syswrite(params[sendpost["ymldata"]])
    lagreyml("epostgrupper") if File.exists?("#{Rails.root}/config/epostgrupper.yml")
    fil = File.open("#{Rails.root}/config/epostgrupper.yml", "w")
    var = params["sendpost"]
    fil.syswrite(var["ymldata"])
    begin
      @ymldata = YAML::load( File.open( "#{Rails.root}/config/epostgrupper.yml") )
    rescue
      @alarm = "Alvorlig feil med yaml fil"
      flash[:error] = norsk2html("<h1>Ups!</h1><p>#{@alarm}</p>")
    end
    redirect_to :action => 'admin'
  end


  def lagreyml(navn, dir = "config", endelse = ".yml")
    t = Time.now
    taar = t.strftime("%Y")
    mnd = t.strftime("%m")
    aarbane = "#{Rails.root}/#{dir}/arkiv_#{navn}/" + taar + "/"
    arkivbane = aarbane + mnd + "/"
    @arkivfil = arkivbane + navn + "_" + t.strftime("%Y-%m-%d-%H-%M-%S") + endelse
    FileUtils.mkdir_p(arkivbane) unless File.exists?(arkivbane)
    @lagraskjemayml = "#{Rails.root}/#{dir}/#{navn}#{endelse}"
    FileUtils.mv(@lagraskjemayml, @arkivfil)
  end
end
