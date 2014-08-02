# -*- encoding : utf-8 -*-
class ArticlesController < ApplicationController
  include ArticlesHelper #ClothSyntax
  include ApplicationHelper #ClothSyntax
  before_filter :nor_authorized?
  before_filter :markitupp
  before_filter :left_column
#  before_filter :set_article
  verify :method => :post, :only => [ :destroy, :create, :update ],
  :redirect_to => { :action => :list }
  #  protect_from_forgery :only => [:update, :delete, :create]    
  # auto_complete_for :article, :source
  # auto_complete_for :autogroup, :name

  # def auto_complete_for_autogroup_name
  #   auto_complete_responder_for_group params[:autogroup][:name]
  # end

  def parse_textile
    #    text = Pressesend.iso_slett_tegn((params[:data]))
    text = params[:data]
    render :text => RedCloth.new(text).to_html
    #    render :text => RedCloth.new(params[:data]).to_html
    #    text = norsk2html(params[:data])
    #    render :text => norsk2html(params[:data])

  end

  def savemiu
    return "MIU:OK"
  end


  def html2textile
    tekst = params[:data]
    #    fil = File.open("/tmp/h2r.html", "w")
    #    fil.syswrite(params[:data])

    tekst = tekst.gsub(/\<font.*?\>/,"")
    tekst = tekst.gsub(/\<span.*?\>/,"")
    tekst = tekst.gsub(/\<\/font\>/,"")
    tekst = tekst.gsub(/\<\/span\>/,"")

    tekst = tekst.gsub(/\n/,"")
    tekst = tekst.gsub(/\<\/?p.*?>/,"")

    tekst = tekst.gsub(/\<td.*?\>(.*)\<\/td\>/){
      z = $1.gsub(/\n/,"")
      %{<td>#{z}</td>}
    }
    tekst = tekst.gsub(/\<li.*?\>(.*)\<\/li\>/){
      z = $1.gsub(/\<\/?p.*?>/,"")
      %{<li>#{z}</li>}
    }

    parser = HtmlToTextileParser.new
    parser.feed(tekst)
    tekst = parser.to_textile
    tekst = tekst.gsub(/\{margin-.*?\}/,"")
    tekst = tekst.gsub(/\{text-align.*?\}/,"")
    tekst = tekst.gsub(/\{font.*?\}/,"")
    tekst = tekst.gsub(/!File.*?!/,"")
    tekst = tekst.gsub(/p\.\s*\n/,"")
    tekst = tekst.gsub(/_ogtegn_lt;/,"<")
    tekst = tekst.gsub(/_ogtegn_gt;/,">")
    tekst = tekst.gsub(/\* p\. /," ")

    tekst = tekst.gsub(/\|\|/,"|")
    #    tekst = tekst.gsub(/(h\d)/,"\n\n#{$1}")
    #    tekst = Pressesend.iso_slett_tegn(tekst)

    tekst = tekst.gsub(/(h\d.*\.) /){
      "\n#{$1} "
    }
    tekst = tekst.gsub(/p\. /){
      "\np. "
    }
    tekst = tekst.gsub(/\n{2,999}/,"\n\n")


    @textile = tekst

    #    @textile = Pressesend.iso_slett_tegn(tekst)
    render(:layout => false)
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

  def clothsyntaxmenue
    cloth = request.raw_post || request.query_string
    @syntax = Pressesend.iso_slett_tegn(clothsyntax(cloth))
    render(:layout => false)
  end

  def troll?
    fil = noryml
    if fil['troll']
      @troll = fil['troll'] 
      @troll.each{ |x|
        if params[:group].include?(x.to_s)
          @treffboks = 1
        end
      }
    end
    if !defined?(@treffboks) && fil['troll']
      flash[:error] = norsk2html("<h1>MANGLER KRYSS I NOEN RØDE BOKSER?</h1> Dersom dette var feil: Rediger artikelen på nytt!<br/><i>#{@flashtxt}</i>")
    else
      flash[:notice] = norsk2html("<p>Vellykket laging/lagring.<br/><i>#{@flashtxt}</i></p>") 
    end
  end

  def articles
    #    group = group_from_name("THEME")
    if @article.cloth
      @syntax = clothsyntax(@article.cloth)
    else
      @syntax = clothsyntax("r")
    end
    @syntax = Pressesend.iso_slett_tegn(@syntax).html_safe

    @groups3 = Group.groups(2)
    gon.groups = Group.temaer(2)
    #gon.groups3 = @groups3
    #gon.groups4 = {"red"=>"r", "blue"=>"b", "media"=>"m", "ingen"=>"0"}
    gon.test8 = "fra ruby"
    gon.groups4 = ["test1", "test2", "kake", "julekake", "kjeks"]
    @lags2 = Group.groups(4)
    @lags = GroupGroup.auth_lags(session[:noruser])

    fil = noryml
    if fil['troll']
      @sentral_group = fil['troll'] 
    else
      @sentral_group = [162, 10, 29, 36, 37] # Fjerna teknisk boksene
      #    @sentral_group = [171, 162, 10, 7, 29, 36, 37] # Groups who will be enlightet when editing/
      # creating articles
    end
    
    @cloth = {"red" => "r",
      "blue" => "b",
      "media" => "m",
      "ingen" => "0"}

      if session[:used_groups]
        @used_groups = session[:used_groups]
      end
    end

    def index
      respond_to do |format|
        format.html
        format.atom
        format.rss
      end

      list
      render :action => 'list'
    end

    def list

      @not_show = ["Url", "Story text", "Suspend", "Ingress", "Un published", "Picture", "Source", "Expires date", "Version"]
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

      if @sort != "created_on"
        sort = "#{@sort} #{@order}, created_on desc"
      else
        sort = "#{@sort} #{@order}"
      end

      @porder = @order
      @stylesheet = "admin"

      @articles = Article.paginate :page => params[:page], :order => sort



      if @order == "asc"
        @order = "desc"
      else
        @order = "asc"
      end

      respond_to do |format|
        format.html
        format.atom
        format.rss
      end


    end

    def show
      @article = Article.find(params[:id])
    end


    def temaboksen
    #    format.js {
    #      render(:update) {|page| page.replace_html 'temaboksen', :partial =>
    #          'articles/edit'}
    #    }
    create_new_common

#    format.js {
#      render :update do |page|
#        page.replace_html 'temaboksen', :partial=>'articles/edit'
#      end
#    }

    #    @group = params[:group]
    #    @group2 = params[:group2]
    #    @groups3 = params[:group3]
    #    @article2 = params[:article2]
    #    @article = Article.find(params[:id])
  end
  
  def new
    create_new_common()
    @article.cloth = "r"
  end

  def edit
    @article2 = Article.find(params[:id])
    if params[:versjon]
      @article = Article.find_version(params[:id], params[:versjon])
      @article.id = @article2.id
    else
      @article = Article.find(params[:id],
        :include => [:article_shows])
    end
    user = Noruser.find(session[:noruser])
    @roles = user.roles.map {|u| [u.name, u.id] } # Selects role name and id for roles user has access to
    articles()
    # unless params[:versjon]
    #  if @article.article_shows.nitems >= 1
    #    if @article.article_shows.first.headline != nil
    #      @hide_headline = 1
    #    end
    #    if @article.article_shows.first.ingress != nil
    #      @hide_ingress = 1
    #    end
    #    if @article.article_shows.first.story_text != nil
    #      @hide_story_text = 1
    #    end
    #    if @article.article_shows.first.source != nil
    #      @hide_source = 1
    #    end
    #    if @article.article_shows.first.dato != nil
    #      @hide_dato = 1
    #    end
    #  end
    # end
    @table = @article
    creator() # In application_controller.rb, uses @table
    updater() # In application_controller.rb, uses @table
  end

  def create_new_common
    if session[:husk]
      @husk = session[:husk]
    end
    @new_article = 1
    if params[:id] # If we are copying an article
      @article = Article.find(params[:id])
    else
      @article = Article.new
    end
    @article2 = @article
    @user = Noruser.find(session[:noruser])
    @roles = @user.roles.map {|u| [u.name, u.id] } # Selects role name and id for roles user has access to
    if session[:role]
      @article.owner = session[:role]
    elsif @roles.first(4)
      @article.owner = 4
    end
    articles()
  end

  def createRAILS
    @article = Article.new(params[:article])
    if @article.save
      flash[:notice] = 'Article was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def create
#    @liste = Liste.new(liste_params)

#    @article = Article.new(params[:article])
    @article = Article.new(article_params)
    @article.created_of = session[:noruser]
    @article.un_published = 0
    @articlegroup = ArticleGroup.new
    if params[:husk]
      session[:husk] = params[:husk]
    else
      session[:husk] = nil
    end
    hide() # Hva skal skjules ved start/view?
    if @article.save
      legginntemaer
      if params[:headlinehide]
        articlehide = ArticleShow.new(
          :article_id => params[:id],
          :headline => '1'
          )
      end
      session[:used_groups] = params[:group]
      troll?
      redirect_to :action => 'new'
      session[:role] = @article.owner
    else
      @article2 = @article
      @user = Noruser.find(session[:noruser])
      @roles = @user.roles.map {|u| [u.name, u.id] } # Selects role name and id for roles user has access to
      articles()
      render :action => 'new'
    end
  end
  
  #  def legginntemaer(value, id)

  def legginntemaer
    params[:group].each { |x|      # ---> Array created of chexboxes
      @article.article_groups << ArticleGroup.new(
        :article_id   => params[:id],
        :group_id => x.first
        )
    }
    arr = params[:autogroup][:name].split(',') # Dytt inn fra den nye autotemasaken
    arr.each{|y|
      Rails.logger.error("var y = #{y}")

      if y =~ /\w/
        tema = Group.find(:all, :conditions => [ "name = ?", y.strip])
        if tema.length > 0
          @article.article_groups << ArticleGroup.new(
            :article_id   => params[:id],
            :group_id => tema.first.id
            )
        else
          storygroup = Group.group_from_name("STORIE_GROUP?")
          group = Group.new
          group.name = y.strip
          group.created_of = session[:noruser]
          if group.save!
            tema2 = Group.find(:all, :conditions => [ "name = ?", group.name])
            @article.article_groups << ArticleGroup.new(
              :article_id   => params[:id],
              :group_id => tema2.first.id
              )
            group.group_groups << GroupGroup.new(
              :group_id   => tema2.first.id,
              :group_id2 => storygroup.id
              )

            @flashtxt = 'Lagde en eller flere nye grupper.'
          end
        end
      end
    }    
  end

  def hide
    if params[:hide]
      if params[:hide]["headline"] == nil
        headline = nil
      else
        headline = 1
      end
      if params[:hide]["ingress"] == nil
        ingress = nil
      else
        ingress = 1
      end
      if params[:hide]["storytext"] == nil
        storytext = nil
      else
        storytext = 1
      end
      if params[:hide]["source"] == nil
        source = nil
      else
        source = 1
      end
      if params[:hide]["dato"] == nil
        dato = nil
      else
        dato = 1
      end
      @article.article_shows << ArticleShow.new(
        :article_id => params[:id],
        :headline => headline,
        :ingress => ingress,
        :source => source,
        :story_text => storytext,
        :dato => dato
        )
    end
  end





  def update
      Rails.logger.info { "Update startet i kontroller" }
    respond_to do |format|
        @article = Article.find(params[:id])
        @article.updated_of = session[:noruser]
        user = Noruser.find(session[:noruser])
        @roles = noruser.roles.map {|u| [u.name, u.id] } # Selects role name and id for roles user has access to
        articles()

        if params[:husk]
          session[:husk] = params[:husk]
        end
        @article.article_shows.clear
        hide() # Hva skal skjules ved start/view?
#        if @article.update_attributes(params[:article])

          @article.article_groups.clear

        if params[:group]
            legginntemaer
            session[:used_groups] = params[:group]
            troll?
          # else
          #   flash[:warning] = "Advarsel: Du hadde ikke kryssa av for noen grupper. Siden vil ikke komme opp noe sted!! G&aring; til stories for &aring; fikse dette. #{@groupallert}"
          # end
#          redirect_to :controller => "start", :action => 'view', :id => @article
          session[:role] = @article.owner
        else
          @article2 = @article
          @user = Noruser.find(session[:noruser])
          @roles = @user.roles.map {|u| [u.name, u.id] } # Selects role name and id for roles user has access to
          articles()
#          render :action => 'edit' and return
        end
      if @article.update(article_params)
        format.html { redirect_to @article, notice: 'Article was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit', notice: 'Article was not updated.' }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def clear_item
    @article = Article.find(params[:id])
    item = Item.new('tekst')
    item.destroy
    redirect_to :action => 'edit', :id => @article
  end

  def destroy#        if x.first == 8
    Article.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

  def un_publish
    @article = Article.find(params[:id])
    @article.un_published = "1"
    @article.save
    redirect_to :action => 'list'
  end

  def publish
    @article = Article.find(params[:id])
    @article.un_published = 'NULL'
    @article.save
    redirect_to :action => 'list'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def article_params
      params.require(:article).permit(:cloth, :created_on, :source, :headline, :ingress, :story_text, :pri, :un_published, :owner, {:autogroup_ids => []}, {:group_ids => []})
    end


end
