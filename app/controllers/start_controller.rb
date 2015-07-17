# -*- encoding : utf-8 -*-
class StartController < ApplicationController
#  layout "Application"
  before_filter :left_column
  #  around_filter BenchmarkingFilter.new
  #  caches_page :group, :advertisement, :right_column


  private

  def sql(temaid = '10', lagid = '8', page = '0')
    @sql = "SELECT a.* FROM articles a
                        JOIN article_groups ag ON ag.article_id = a.id
                        WHERE
                        a.un_published != '1' AND
                        ag.group_id IN (?, ?)
                        GROUP BY a.id
                        HAVING COUNT(DISTINCT ag.group_id) = 2"
    # sql2 = "SELECT a.id FROM articles a
    #                     JOIN article_groups ag ON ag.article_id = a.id
    #                     WHERE
    #                     a.un_published != '1' AND
    #                     ag.group_id IN (?, ?)
    #                     GROUP BY a.id
    #                     HAVING COUNT(DISTINCT ag.group_id) = 2"
    # csql = Article.find_by_sql([sql2, temaid, lagid])
    # @count_condition_sql = "SELECT FOUND_ROWS()"
    # @article_pages = Paginator.new self, ArticleGroup.count_by_sql(["#{@count_condition_sql}", temaid]), 10, page
  end


  def group(temaid = params[:id], lagid = params[:lagid], page = params[:page], controller = "index")
    @right_column = 1
    group = Group.find(temaid)
    @description = group.description
    @groupname = group.name
    grouplag = Group.find(lagid)
    @lagid = lagid
    session[:lagid] = lagid
    norinitialize()
    @lag_name = grouplag.name
    @temaid = temaid

    sql(@temaid, @lagid)
    @articles = Article.paginate_by_sql(["#{@sql}
                                           ORDER BY a.pri desc,
                                           a.created_on desc",
        temaid, lagid], :page => page, :per_page => 10)
    render :controller => controller, :action => "index"
    #    respond_to do |format|
    #      format.html {render :controller => controller, :action => "index"}
    ##      format.atom {render :controller => "lag", :action => "index"}
    #      format.atom {render :controller => controller, :action => "index"}
    #    end

  end

  public
  def advertisement # kan slettes?
    @articles = Article.find(:all,
      :conditions => id = '1',
      :limit => 1)
    @no_paginating = 1
    render :action => 'lag', :layout => false
  end

  # Flyttet til Start Model
  def venstre_meny(temaid = params[:temaid], lagid = params[:lagid])
    if !lagid
      if session[:lagid]
        lagid = session[:lagid]
      else
        lagid = 8
      end
    end
    sql_from_only_one_group(temaid, lagid)
    group_id = 168
    @articles = Article.find_by_sql(["#{@sql}
                                           ORDER BY a.pri desc,
                                           a.created_on desc", #"
        lagid, group_id])
    @no_paginating = 1
    render :layout => false
  end

  def bunntekst(temaid = params[:temaid], lagid = params[:lagid])
    if !lagid
      if session[:lagid]
        lagid = session[:lagid]
      else
        lagid = 8
      end
    end
    sql_from_only_one_group(temaid, lagid)
    group_id = 171
    @articles = Article.find_by_sql(["#{@sql}
                                           ORDER BY a.pri desc,
                                           a.created_on desc", #"
        lagid, group_id])
    @no_paginating = 1
    render :layout => false
  end

  # topplinker aksjonen kan slettes:
  def topplinker(temaid = params[:temaid], lagid = params[:lagid])
    if !lagid
      if session[:lagid]
        lagid = session[:lagid]
      else
        lagid = 8
      end
    end
    sql_from_only_one_group(temaid, lagid)
    group_id = 5
    @articles = Article.find_by_sql(["#{@sql}
                                           ORDER BY a.pri desc,
                                           a.created_on desc limit 0,1", #"
        lagid, group_id])
    @no_paginating = 1
    render :layout => false
  end


  def right_column(temaid = params[:temaid], lagid = params[:lagid])
    fil = YAML::load( File.open( "#{Rails.root}/config/nor.yml") )
    antall = fil['ANTALL']
    raise "Can't find domenelink!" if !fil['MOTTO']

    @lagid = lagid
    lag = Group.find(lagid)
    @lag = lag.name
    #    @lag = "Sentralt" unless @lag =~ /\w/
    #    @lag = "Sentralt"
    sql_from_only_one_group(temaid, lagid)
    group_id = 7
    @articles = Article.find_by_sql(["#{@sql}
                                           ORDER BY a.pri desc,
                                           a.created_on desc limit 0, ?", #"
        lagid, group_id, antall])
    @no_paginating = 1
    @fra_sted = 1
    render :action => 'lag', :layout => false
  end

  def show(lagid = params[:lagid], lagname = params[:lag])

    #    redirect_to :action => "view"
    #
    lagid = 8 unless params[:lagid]
    lagname = "Sentralt" unless params[:lag]
    view(lagid, lagname)

    #    render :action => 'view'
    respond_to do |format|
      format.html {render :controller => "start", :action => "view"}
      format.rss {render :controller => "start", :action => "view"}
      format.atom {render :controller => "start", :action => "view"}
    end

  end

  def print(lagid = params[:lagid], lagname = params[:lag])
    @print = 1
    view(lagid, lagname)
    #    render :action => 'view', :layout => false

    fil = YAML::load( File.open( "#{Rails.root}/config/nor.yml") )
    @stilarkid = fil['PRINTSTILARKID']
    raise "Can't find stilarkid!" if !fil['PRINTSTILARKID']    
    #    render :layout => 'print'
    render :action => 'view', :layout => 'print'
  end
  
  def view(lagid = params[:lagid], lagname = params[:lag])
    @view = 1
#    lag = Group.group_from_name(lagname)
    lag = Group.find_by("name = ?", lagname)

    if !lagid && !lag
      lagid = 8
    elsif lag && !lagid
      lagid = lag.id
    end

    grouplag = Group.find(lagid)
    @lagid = lagid
    norinitialize()

    if !lag
      lagname = grouplag.name
    end
    @lag = lagname
    @lag_name = lagname

    @article = Article.find(params[:id])

    unless @article.story_text =~ /\[\[tema=.*\]\]/ || @article.ingress =~ /\[\[tema=.*\]\]/
      if @article.story_text =~ /(bilde-li)\:(\w*)/
        @bildeview = $2
      elsif @article.story_text =~ /(bilde-st)\:(\w*)/
        @bildeview = $2
      elsif @article.ingress =~ /(bilde-li)\:(\w*)/
        @bildeview = $2
      elsif @article.ingress =~ /(bilde-st)\:(\w*)/
        @bildeview = $2
      end
      @bilderetning = $1 if defined?(@bildeview)
    end
    
    show = @article.article_shows
    test = show.first
    if defined?(@article.article_shows.first["headline"]) && @article.article_shows.first["headline"] != nil
      @visheadline = 1
    end
    if defined?(@article.article_shows.first["source"]) && @article.article_shows.first["source"] != nil
      @vissource = 1
    end
    if defined?(@article.article_shows.first["story_text"]) && @article.article_shows.first["story_text"] != nil
      @visstory_text = 1
    end
    if defined?(@article.article_shows.first["ingress"]) && @article.article_shows.first["ingress"] != nil
      @visingress = 1
    end
    if defined?(@article.article_shows.first["dato"]) && @article.article_shows.first["dato"] != nil
      @visdato = 1
    end
    
        #unless @print == 1
        #  respond_to do |format|
        #    format.html
        #    format.atom
        #  end
        #end

    if @article.un_published == 1
      #      flash[:error] = "<p>Siden finnes ikke</p>"
      @fraurl = "http://" + @domene + request.url
      render :action => "404", :status => 404
      #      redirect_to("/")# if request.referer == nil
    end

  end

  def search
    @right_column = 1
  end

  def search_result
    if !@lag
      @lag = "Sentralt"
    end
    #    @page = params[:page] if params[:page]

    if params[:page]
      page = params[:page]
    else
      page = 1
    end
    @right_column = 1
    if params[:tekst]
      session[:tekst] = params[:tekst]
      @tekst = params[:tekst]
    else
      @tekst = session[:tekst]
    end

    @articles = Ultrasphinx::Search.new(
      :query => @tekst,
      :page => page,
      :per_page => '10')
    @articles.run
    @articles.results
    #    @search = Ultrasphinx::Search.new(:query => @tekst)
    #    @search.run
    #    @search.results

    #   @articles = @search
    #   @start = @articless
    norinitialize()
    render :action => 'lag'
  end
  #  def search_result
  #    if !@lag
  #      @lag = "Sentralt"
  #    end
  #    @right_column = 1
  #    if params[:tekst]
  #      session[:tekst] = params[:tekst]
  #      @tekst = params[:tekst]
  #    else
  #      @tekst = session[:tekst]
  #    end
  #    count_condition_sql = "select count(*) FROM articles
  #                           WHERE un_published != '1'
  #                           AND MATCH (headline, ingress, story_text)
  #                           AGAINST (?)" #"
  #    @article_pages = Paginator.new self, Article.count_by_sql(["#{count_condition_sql}", @tekst]), 10 , params[:page]
  #    @articles = Article.find_by_sql(
  #      ["SELECT * FROM articles
  #                                      WHERE un_published != '1'
  #                                      AND MATCH (headline, ingress, story_text)
  #                                      AGAINST (?) order by articles.pri desc,
  #                                      articles.created_on desc limit ?, ?",
  #        @tekst, @article_pages.current.offset,
  #        @article_pages.items_per_page]) #"
  #    norinitialize()
  #    render :action => 'lag'
  #  end
end
