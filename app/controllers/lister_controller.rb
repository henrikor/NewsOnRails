# -*- encoding : utf-8 -*-
class ListerController < ApplicationController
  include NorAuthorize
  include NorFelles
  include AuthenticatedSystem

  
  before_filter :nor_logged_in?
  before_filter :klargjor
  before_filter :left_column
  #  permit "Admin", :except => :index
  #  permit "Admin or RoleAdmin or UserAdmin"
  before_filter :authorized?

  
  #  
  #  before_filter :left_column
  #  before_filter :nor_authorized?
  require 'fileutils'
  include FileUtils::Verbose

  def variabler
    fil = YAML::load( File.open( "#{Rails.root}/config/nor.yml") )
    @emailRE = emailreg2()
    @mlmmj_path = fil['mlmmj_path'] if defined?(fil['mlmmj_path']) and not fil['mlmmj_path'] == nil
    @mlmmj_path = "/usr/bin/" unless defined?(fil['mlmmj_path']) and not fil['mlmmj_path'] == nil
    @list_path = fil['list_path']  #"/var/www/sites/sos/sos-rasisme.no/lists/"
    @listerMDOMENE = `ls #{@list_path}`
    @lister = Array.new
    @listerMDOMENE.each{|x|
      liste = x.gsub("#{@domene}_", "")
      @lister << liste
    }
    @eposter = Array.new
    @adr = Array.new
  end
  def index
    list
    render :action => 'list'
  end

  def norusers2list    
    variabler()
    @listenavn = "web.skrivere"
    @listemdomene = "#{@domene}_#{@listenavn}"
    gamleadresser = `#{@mlmmj_path}mlmmj-list -L #{@list_path}#{@listemdomene}`
    #    avmlengde = avmeld(gamleadresser)


    avmlengde = 0

    gamleadresser.scan(@emailRE) { |w| @adr << w}
    @adr.each{ |x|
      `#{@mlmmj_path}mlmmj-unsub -L #{@list_path}#{@listemdomene} -a #{x.strip}`
      `echo "#{@mlmmj_path}mlmmj-unsub -L #{@list_path}#{@listemdomene} -a #{x.strip}" >> /tmp/nortest2`
      avmlengde = avmlengde + 1
    }

    #    Noruser.find_each do |user|
    adresser = Noruser.all(:select => "email")
    #    adresser = Noruser.all
    adresser.each do |user|
      `#{@mlmmj_path}mlmmj-sub -L #{@list_path}#{@listemdomene} -a #{user.email.strip}`
      `echo "#{@mlmmj_path}mlmmj-sub -L #{@list_path}#{@listemdomene} -a #{user.email.strip}" >> /tmp/nortest3`
    end
    adrlengde = adresser.size
    #    flash[:notice] = "#{adrlengde} adresser blei lagt til og #{avmlengde} adresser blei meldt ut"
    flash[:notice] = "#{adrlengde} adresser blei lagt til og #{avmlengde} adresser blei meldt ut"

    redirect_to :action => "list", :params => { :liste => @listenavn, :adresser => params[:adresser]}
  end
  def list
    variabler()
    if params[:liste]
      @liste = params[:liste]
      if @liste[:id]
        @listenavn = @liste[:id]
      else
        @listenavn = @liste
      end
      @listemdomene = "#{@domene}_#{@listenavn}"
      @eposter = `#{@mlmmj_path}mlmmj-list -L #{@list_path}#{@listemdomene}`
    else
      @eposter << "Velg liste"
    end
  end

  def add
    variabler()
    if !params[:liste] || params[:liste].empty?
      flash[:notice] = "Mangler liste"
      redirect_to :action => "list"
    else
      @listenavn = params[:liste]
      @listemdomene = "#{@domene}_#{@listenavn}"
      if params[:adresser] && !params[:adresser].empty?
        flash[:notice] = "Registrert adresse"
        innmeld(params[:adresser][:id])
      end
      if params[:avmelde]
        avmlengde = avmeld(params[:avmelde])
      end
      if @adr
        adrlengde = @adr.length
      else
        adrlengde = "0"
      end
    end
    flash[:notice] = "#{adrlengde} adresser blei lagt til og #{avmlengde} adresser blei meldt ut"
    redirect_to :action => "list", :params => { :liste => params[:liste], :adresser => params[:adresser]}
  end

  def innmeld(adresser)
    adresser.scan(@emailRE) { |w| @adr << w}
    @adr.each{ |x|
      `#{@mlmmj_path}mlmmj-sub -L #{@list_path}#{@listemdomene} -a #{x.strip}`
      `echo "#{@mlmmj_path}mlmmj-sub -L #{@list_path}#{@listemdomene} -a #{x.strip}" >> /tmp/nortest2`
    }
  end
  def avmeld(avmeldearr)
    avmlengde = 0
    avmeldearr.each{ |name, value|
      if value == "1"
        `#{@mlmmj_path}mlmmj-unsub -L #{@list_path}#{@listemdomene} -a #{name.strip}`
        `echo "#{@mlmmj_path}mlmmj-unsub -L #{@list_path}#{@listemdomene} -a #{name}" >> /tmp/nortest2`
        avmlengde = avmlengde + 1
      end
    }
    return avmlengde
  end
end
