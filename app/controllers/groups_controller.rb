# -*- encoding : utf-8 -*-
class GroupsController < ApplicationController
  include ArticlesHelper #ClothSyntax
#  before_filter :nor_authorized?, :except => [:temaer]
#  before_filter :nor_logged_in?
  before_filter :klargjor
  before_filter :nor_authorized?
  before_filter :markitupp

  before_filter :left_column
  before_filter :nor_authorized?, :except => [:temaer]

  #  permit "Admin or GroupAdmin"


  def temaer
    unless defined?(@lag_name)
      @lag_name = "Sentralt"
    end
    #    @group_pages, @groups = paginate :group, :per_page => 10
    @groups = Group.groups(2)
  end
  def felles
    @syntax = clothsyntax("r")
  end

  def index
    list
    render :action => 'list'
  end

  def list
    @not_show = ["Description", "Suspend", "Expires date"]
    if params[:sort]
      @sort = params[:sort]
    else
      @sort = "created_on"
    end
    if params[:order]
      @order = params[:order]
    else
      @order = "desc"
    end
    #    @psort = @sort
    if @sort != "created_on"
      sort = "#{@sort} #{@order}, created_on desc"
    else
      sort = "#{@sort} #{@order}"
    end
    @porder = @order
    @stylesheet = "admin"
    @groups = Group.paginate :page => params[:page], :order => sort
    if @order == "asc"
      @order = "desc"
    else
      @order = "asc"
    end
  end

  def home
    @groups = GroupGroup.auth_lags(session[:noruser]) #paginate :group, :per_page => 10
    #    @lags = GroupGroup.auth_lags(session[:noruser])
    #    render :partial => 'index'
  end

  def show
    @group = Group.find(params[:id])
  end

  def new
    felles()
    @group = Group.new
    @table = @group
    @stylesheet = Stylesheet.find(:all)
    @groups3 = Group.groups()
  end

  def edit
    felles()
    @group = Group.find(params[:id])
    @table = @group
    @stylesheet = Stylesheet.find(:all).map {|u| [u.name, u.id] } # Selects role name and id for roles user has access to
    creator() # In application.rb, uses @table
    updater() # In application.rb, uses @table
    @groups3 = Group.groups()
    @stylesheets = Group.stylesheets()
  end

  def slett
    felles()
    @group = Group.find(params[:id])
    @table = @group
    @stylesheet = Stylesheet.find(:all).map {|u| [u.name, u.id] } # Selects role name and id for roles user has access to
    creator() # In application.rb, uses @table
    updater() # In application.rb, uses @table
    @temaer = Group.groups("2")
    @groups3 = Group.groups()
    @stylesheets = Group.stylesheets()
  end

  def move
#    if params[:id] && group = Group.find(params[:id]) && params[:til_group][:id] && Group.find(params[:til_group][:id])
    begin
        Group.move(params[:id], params[:til_group][:id])
#        Group.find(params[:id]).destroy
        flash[:notice] = "Group deleted"
      rescue
        flash[:error] = "Sletting misslyktes"
#      end
    end
    redirect_to :action => 'list'
  end

  def auto_complete_responder_for_group(value)
    @temaer = GroupGroup.find(:all,
      :include => [:group],
      :conditions => [ "group_groups.group_id2 = '2' and LOWER(groups.name) LIKE ?",
        '%' + value.downcase + '%'],
      :order => 'groups.name ASC',
      :limit => 8)
    render :partial => 'groups'
  end

  def create
    groups_select()
    @group = Group.new(group_params)
    @group.created_of = session[:noruser]
    #    @table = @group
    #    creator() # In application.rb, uses @table
    #    updater() # In application.rb, uses @table
    if @group.save
      if params[:group_id]
        params[:group_id].each { |x|  # Array created of chexboxes
          @group.group_groups << GroupGroup.new(
            :group_id   => params[:id],
            :group_id2 => x.first
          )
        }
      end
      flash[:notice] = 'Article was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def update
    groups_select()
    @group = Group.find(params[:id])
    @group.updated_of = session[:noruser]

    if @group.update_attributes(group_params)
      @group.group_groups.clear
      if params[:group_id]
        params[:group_id].each { |x|  # Array created of chexboxes
          @group.group_groups << GroupGroup.new(
            :group_id   => params[:id],
            :group_id2 => x.first
          )
        }
      end
      flash[:notice] = 'Group was successfully updated.'
      redirect_to :action => 'show', :id => @group
    else
      render :action => 'edit'
    end
  end

  def destroy
    if params[:id] && group = Group.find(params[:id])
      begin
        Group.find(params[:id]).destroy
        flash[:notice] = "Group #{group.name} deleted"
      rescue
        flash[:error] = "Can't delete systemgroup #{group.name}"
      end
    end
    redirect_to :action => 'list'
  end
  def group_params
    params.require(:group).permit(:name, :description, {:group_ids => []}, {:suspend_ids => []}, {:expire_date_ids => []})
  end


end
