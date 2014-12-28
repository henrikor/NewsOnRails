# -*- encoding : utf-8 -*-
class ImagesController < ApplicationController
  include ApplicationHelper #ClothSyntax
  
  before_filter :nor_authorized?
  
  def new(mappe="default")
    if mappe != "default"
      mappe = mappe
    end
#    @images = Image.find :all
#    @image_pages, @images = paginate(:images, :order => "created_at desc", :per_page => 20)
    @images = Image.paginate :page => params[:page], :order => "created_at desc" # (:images, :order => "created_at desc", :per_page => 20)
#    @articles = Article.paginate :page => params[:page], :order => sort

    @image = Image.new
    @dirs = Image.files_in_dir #("test")
    @action = "create"
  end

  def edit
    @images = Image.paginate :page => params[:page], :order => "created_at desc" # (:images, :order => "created_at desc", :per_page => 20)
    @image = Image.find(params[:id])
    @dirs = Image.files_in_dir
    @action = "update"
    render :action => 'new'
  end

  def create
    @image = Image.create(params[:image])
    redirect_to :action => 'new'
  end

  def update
    image = params[:id]
    # @image = Image.find(params[:image].first.id)
    @image = Image.find(params[:id])
#    if params[:image].file == nil
#      params[:image].file = @image.file
#    end
    @image.update_attributes(params[:image])
    redirect_to :action => 'new'
  end

  def clean
    Image.destroy_all
    redirect_to :action => 'new'
  end

  def destroy
    Image.find(params[:id]).destroy
    redirect_to :action => 'new'
  end

end
