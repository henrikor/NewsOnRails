# -*- encoding : utf-8 -*-
class GroupMembersController < ApplicationController
before_filter :nor_authorized?
  def index
    list
    render :action => 'list'
  end

  def list
    @group_member_pages, @group_members = paginate :group_member, :per_page => 10
  end

  def show
    @group_member = GroupMember.find(params[:id])
  end

  def new
    users_select()
    groups_select()
    @group_member = GroupMember.new
  end

  def create
    @group_member = GroupMember.new(params[:group_member])
    if @group_member.save
      flash[:notice] = 'GroupMember was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @group_member = GroupMember.find(params[:id])
    users_select()
    groups_select()
  end

  def update
    @items = Item.find_recent
#    @items.each
    @group_member = GroupMember.find(params[:id])
    if @group_member.update_attributes(params[:group_member])
      flash[:notice] = 'GroupMember was successfully updated.'
      redirect_to :action => 'show', :id => @group_member
    else
      render :action => 'edit'
    end
  end

  def destroy
    GroupMember.find(params[:id]).destroy
    redirect_to :action => 'list'
  end


end
