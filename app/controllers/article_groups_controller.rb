# -*- encoding : utf-8 -*-
class ArticleGroupsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  def list
    @article_group_pages, @article_groups = paginate :article_groups, :per_page => 10
  end

  def show
    @article_group = ArticleGroup.find(params[:id])
  end

  def new
    @article_group = ArticleGroup.new
  end

  def create
    @article_group = ArticleGroup.new(params[:article_group])
    if @article_group.save
      flash[:notice] = 'ArticleGroup was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @article_group = ArticleGroup.find(params[:id])
  end

  def update
    @article_group = ArticleGroup.find(params[:id])
    if @article_group.update_attributes(params[:article_group])
      flash[:notice] = 'ArticleGroup was successfully updated.'
      redirect_to :action => 'show', :id => @article_group
    else
      render :action => 'edit'
    end
  end

  def destroy
    ArticleGroup.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
