# -*- encoding : utf-8 -*-
class GroupGroupsController < ApplicationController
  before_filter :nor_authorized?
  def index
    list
    render :action => 'list'
  end

  def list
    @group_group_pages, @group_groups = paginate :group_groups, :per_page => 10
  end

  def show
    @group_group = GroupGroup.find(params[:id])
  end

  def new
    @group_group = GroupGroup.new
    groups_select()
  end

  def create
    params[:group_id].each { |x|  # Array created of chexboxes
      @group_group = GroupGroup.new(params[:group_group])
      @group_group.created_of = session[:noruser]
      @group_group.group_id = x.first


      if @group_group.save
        params[:group].each { |x|  # Array created of chexboxes
          @article.article_groups << ArticleGroup.new(
                                                      :article_id   => params[:id],
                                                      :group_id => x.first
                                                      )
        }
        flash[:notice] = 'Article was successfully created.'
        redirect_to :action => 'list'
      else
        render :action => 'new'
      end
    }
  end


  #    @group_group.group_id2 = 6
  #    @group_group.group_id = 2

  #  def create
  #    @group_group = GroupGroup.new(params[:group_group])
  #    @group_group.created_of = session[:noruser]
  #    @table = @group_group
  #    creator() # In application.rb, uses @table
  #    updater() # In application.rb, uses @table
  #    @group_groupgroup = GroupGroup.new
  #    if @group_group.save
  #      @items.each { |x|  # Alle grupper ligger i @items, og puttes her inn i group_group_groups tabellen.
  #        @group_group.group_group_groups << GroupGroup.new(
  #                                        :group_group_id   => params[:id],
  #                                        :group_id => x.body
  #                                        )
  #                                      }
  #
  #      flash[:notice] = 'GroupGroup was successfully created.'
  #      redirect_to :action => 'list'
  #    else
  #      render :action => 'new'
  #    end
  #  end


  def edit
    @group_group = GroupGroup.find(params[:id])
  end

  def update
    @group_group = GroupGroup.find(params[:id])
    if @group_group.update_attributes(params[:group_group])
      flash[:notice] = 'GroupGroup was successfully updated.'
      redirect_to :action => 'show', :id => @group_group
    else
      render :action => 'edit'
    end
  end

  def destroy
    GroupGroup.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end

