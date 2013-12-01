# -*- encoding : utf-8 -*-
class ArticleMembersController < ApplicationController
before_filter :authorize_action
  def index
    list
    render :action => 'list'
  end

  def list
    @article_member_pages, @article_members = paginate :article_member, :per_page => 10
  end

  def show
    @article_member = ArticleMember.find(params[:id])
  end

  def new
    @article_member = ArticleMember.new
  end

  def create
    @article_member = ArticleMember.new(params[:article_member])
    if @article_member.save
      flash[:notice] = 'ArticleMember was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @article_member = ArticleMember.find(params[:id])
  end

  def update
    @article_member = ArticleMember.find(params[:id])
    if @article_member.update_attributes(params[:article_member])
      flash[:notice] = 'ArticleMember was successfully updated.'
      redirect_to :action => 'show', :id => @article_member
    else
      render :action => 'edit'
    end
  end

  def destroy
    ArticleMember.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
