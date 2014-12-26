# -*- encoding : utf-8 -*-
class StylesheetsController < ApplicationController
  include NorAuthorize
  before_filter :nor_logged_in?
  before_filter :klargjor
  before_filter :left_column
  before_filter :nor_authorized?

  # GET /stylesheets
  # GET /stylesheets.xml
  def index
    @stylesheets = Stylesheet.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @stylesheets }
    end
  end

  # GET /stylesheets/1
  # GET /stylesheets/1.xml
  def show
    @stylesheet = Stylesheet.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @stylesheet }
    end
  end

  # GET /stylesheets/new
  # GET /stylesheets/new.xml
  def new
    @stylesheet = Stylesheet.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @stylesheet }
    end
  end

  # GET /stylesheets/1/edit
  def edit
    @stylesheet = Stylesheet.find(params[:id])
  end

  # POST /stylesheets
  # POST /stylesheets.xml
  def create
    @stylesheet = Stylesheet.new(css_params)

    respond_to do |format|
      if @stylesheet.save
        Stylesheet.css_fil_save(@stylesheet.id, @stylesheet.css)
        
        flash[:notice] = 'Stylesheet was successfully created.'
        format.html { redirect_to(@stylesheet) }
        format.xml  { render :xml => @stylesheet, :status => :created, :location => @stylesheet }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @stylesheet.errors, :status => :unprocessable_entity }
      end
    end
  end

  
  # PUT /stylesheets/1
  # PUT /stylesheets/1.xml
  def update
    @stylesheet = Stylesheet.find(params[:id])

    respond_to do |format|
      if @stylesheet.update_attributes(css_params)
        
        Stylesheet.css_fil_save(@stylesheet.id, @stylesheet.css)

        flash[:notice] = 'Stylesheet was successfully updated.'
        format.html { redirect_to(@stylesheet) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @stylesheet.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /stylesheets/1
  # DELETE /stylesheets/1.xml
  def destroy
    @stylesheet = Stylesheet.find(params[:id])
    @stylesheet.destroy

    respond_to do |format|
      format.html { redirect_to(stylesheets_url) }
      format.xml  { head :ok }
    end
  end
  def css_params
    params.require(:stylesheet).permit(:created_of, :name, :css)
  end

end
