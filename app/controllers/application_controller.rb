# -*- encoding : utf-8 -*-
#-*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  protect_from_forgery
  include NorAuthorize
  include AuthenticatedSystem
  before_filter :left_column
  before_filter :klargjor


  #  before_filter :login_from_cookie # f�r dessverre ikke denne til � funke n�


  #  helper :user
  #  model :user


  after_filter :set_charset


  #  def authorized_to?(user)
  #    Noruser.login != "bob"
  #  end


  class Helper
    include Singleton
#    include ActionView::Helpers::ArticlesHelper #or whatever helpers you want
  end
  def apphelp
    Helper.instance
  end

  def set_charset
    #    headers["Content-Type"] = "text/html; charset=iso-8859-1"
    headers["Content-Type"] = "text/html; charset=utf-8"
  end
  def markitupp
    @content_submission = 1
  end

  def klargjor
    fil = YAML::load( File.open( "#{Rails.root}/config/nor.yml") )

    @htmlmeta = fil['META'].html_safe
#    @htmlmeta = "test"

    @domenelink = fil['DOMENELINK'].html_safe
    raise "Can't find domenelink!" if !fil['DOMENELINK']

    @domene = fil['DOMENE'].html_safe
    raise "Can't find domene!" if !fil['DOMENE']

    @googleanalytics = fil['GOOGLEANALYTICS'].html_safe if fil['GOOGLEANALYTICS']

    @googlesok = fil['GOOGLESOK'].html_safe if fil['GOOGLESOK']
    raise "Kan ikke finne Googlesok partner verdi i nor.yml!" if !fil['GOOGLESOK']

    @googlesok_str1 = fil['GOOGLESOK_STR1'] if fil['GOOGLESOK_STR1']
    @googlesok_str1 = "31" if !fil['GOOGLESOK_STR1']
    @googlesok_str2 = fil['GOOGLESOK_STR2'] if fil['GOOGLESOK_STR2']
    @googlesok_str2 = "10" if !fil['GOOGLESOK_STR2']

    @organization = fil['ORGANIZATION'].html_safe
    raise "Can't find domenelink!" if !fil['ORGANIZATION']

    @motto = fil['MOTTO'].html_safe
    raise "Can't find domenelink!" if !fil['MOTTO']

    @felles_stylesheet = Stylesheet.find(1)
    if defined?(session[:noruser])
      @user_loggen_inn = 1
    end
    if !@nor_stylesheet
      @adm_stylesheet = Stylesheet.find(3)
    end
    #    if session && session[:noruser] && !session[:noruser].nil?
    #     @user = session[:noruser] #Noruser.find(session[:noruser])
    #    end
  end

  def norinitialize
    if !@lagid
      @lagid = 8
    end

    session[:lagid] = @lagid

    group = Group.find(@lagid)
    @nor_stylesheet = group.stylesheets
  end

  def left_column
    # group = Group.group_from_name("LEFTCOLUMN")
    group = Group.find_by(name: "LEFTCOLUMN")
#    article_group = Group.group_from_name("leftcolumn_stori")
    article_group = Group.find_by(name: "leftcolumn_stori")
    # @groups_left_column = GroupGroup.find(:all,
    #   :include => [:group],
    #   :conditions => ["group_groups.group_id2 = ?", group.id])

    @groups_left_column = GroupGroup.joins(:group).where("group_groups.group_id2 = ?", group.id)

    # @articles_left_column = ArticleGroup.find(:all,
    #   :include => [:group],
    #   :conditions => ["article_groups.group_id = ?", article_group.id])

    @articles_left_column = ArticleGroup.joins(:group).where("group_groups.group_id = ?", article_group.id)


    #    render(:controller => "start", :action => left_column)
    #    render(:layout => false)
  end

  def sql(sql2) # Finn alle laggrupper hvor en av brukers roller er medlem.
    sql = "SELECT gt.* FROM group_groups gt # Distinct for kun unike treff
                        JOIN groups g ON g.id = gt.group_id
                        JOIN group_roles gr ON g.id = gr.group_id
                        JOIN norusers_roles ur ON gr.role_id = ur.role_id
                        WHERE
                        gt.group_id2 = 4 # lag group. Ikke tull med denne
                        AND
                        gr.role_id IN (SELECT role_id FROM norusers_roles WHERE noruser_id = ?)"  # Role writer_stab

  end

  def article_from_name(name)
    article = Article.find(:first,
      :conditions => "name = '#{name}'")
  end
  def group_from_name(name) #Moved to Group
    flash[:warning] = "Warning: This method has moved to Group. Change to Group.group_from_name"
    #    group = Group.find(:first,
    #                          :conditions => "name = '#{name}'")
  end

  def list_item
    @items = Item.find_recent
    render(:template => "shared/list_item", :layout => false)
  end

  def add_item
    @phrase  = request.raw_post || request.query_strin
    @phrase2 = (@phrase.sub(/&.*/, ''))
    @item = find_item
    @item.add
    render(:partial => "/shared/item", :object => @item, :layout => false)
  end

  def del_item
    @items = Item.find_recent
    if @items.length <= 1
      flash[:warning] = "Warning: You must have at least one group. Add another group befor you try to delete this again."
      redirect_to :back
    else
      item = Item.new(params[:id])
      a = item.del
      redirect_to :back
    end
  end

  def current_user
    noruser
  end
  def users_select
    @thing = [["select User", "empty"]] + Noruser.find(:all, :order => "login").map {|u| [u.login, u.id] }
    @thing2 = Noruser.find(:all, :order => "login")
  end

  def groups_select
    @groups2 = [["select_group", "empty"]] + Group.find(:all, :order => "name").map {|u| [u.name, u.id] }
    @groups3 = Group.find(:all, :order => "name")
    @items = Item.find_recent
    #    flash[:notice] = "Groupid #{params[:id]}"
  end
  def creator
    @creator_arr = Noruser.find(@table.created_of)
    @creator = @creator_arr.login
  rescue
    @creator = "Creator dosn't exist!"
  end
  def updater
    @updater_arr = Noruser.find(@table.updated_of)
    @updater = @updater_arr.login
  rescue
    @updater = "Not updated"
  end

  def advertisement #In upper right corner
    @hoyreboks = Article.find(:all,
      :conditions => id = '1',
      :limit => 1)
    @no_paginating = 1
    render :controller => 'start', :action => 'lag', :layout => false
  end

  def rescue_404
#    rescue_action_in_public CustomNotFoundError.new
#      render :template => "shared/error404", :layout => "standard", :status => "404"
      render :status => 404, :layout => false
  end

  def rescue_action_in_public(exception)
    case exception
    when CustomNotFoundError, ::ActionController::UnknownAction then
      #render_with_layout "shared/error404", 404, "standard"
      render :template => "shared/error404", :layout => "standard", :status => "404"
    else
      @message = exception
      render :template => "shared/error", :layout => "standard", :status => "500"
    end
  end

  def local_request?
    return false
  end

  private
  def find_item
    #    session[:item] ||= Item.new(@phrase2)
    Item.new(@phrase2)
  end

end
