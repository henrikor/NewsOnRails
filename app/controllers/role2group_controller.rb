# -*- encoding : utf-8 -*-
class Role2groupController < ApplicationController
#  before_filter :authorize_action
#  before_filter :left_column
  include NorAuthorize  
  before_filter :nor_logged_in?
  before_filter :klargjor
  before_filter :left_column
  before_filter :nor_authorized?

#  before_filter :adm_klargjor

  def groups
    @groups2 = [["select_group", "empty"]] + Group.find(:all, :order => "name").map {|u| [u.name, u.id] }
    group = Group.group_from_name("THEME")
    @groups3 = GroupGroup.find(:all,
                          :include => [:group],
                          :conditions => ["group_groups.group_id2 = '2'"], # Storie_group? group
                          :order => "groups.name")

    @lags = GroupGroup.find(:all,
                          :include => [:group],
                          :conditions => ["group_groups.group_id2 = '4'"], # lag group
                          :order => "groups.name")

#        @lags = Group.find(:all)

  end

  def index
    list
    render :action => 'list'
  end

  def list
    @stylesheet = "admin"
#    @role_pages, @roles = paginate :roles, :per_page => 10
    @roles = Role.paginate :page => params[:page], :order => 'created_at DESC'
    @role2group = @roles
  end

  def show
    @role = Role.find(params[:id])
  end

  def edit
    @role2groups = Role.find(:all).map {|u| [u.name, u.id] }
    @role2group = Role.find(params[:id])
    groups()
  end

  def update
    @role = Role.find(params[:id])
#    @role = Role.find(5)
#    @rolegroup = GroupRole.new
#    if @role.update_attributes(params[:role])
#    if @role.update(params[:role])
#    if @role.update_attributes(role_params)

   if @role.update(role_params)
      grouprole = GroupRole.where(role_id: params[:id])
      grouprole.each do |a|
        a.destroy
      end

#      @role.group_roles.clear
      params[:group].each { |x|  # Array created of chexboxes
        @role.group_roles << GroupRole.new(
                                                    :role_id   => params[:id],
                                                    :group_id => x.first
                                                    )
      }
#           @first.clear
      flash[:notice] = 'Role was successfully updated.'
      redirect_to :action => 'show', :id => @role
    else
      render :action => 'edit'
    end
  end
  def role_params
    params.require(:group).permit({:group_ids => []})
  end

end
