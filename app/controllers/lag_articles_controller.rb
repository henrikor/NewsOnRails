# -*- encoding : utf-8 -*-
class LagArticlesController < ArticlesController
  before_filter :authorize_action
  before_filter :left_column

  def articles
    @groups2 = [["select_group", "empty"]] + Group.find(:all, :order => "name").map {|u| [u.name, u.id] }
    group = group_from_name("THEME")
    @groups3 = GroupGroup.find(:all,
                          :include => [:group],
                          :conditions => ["group_groups.group_id2 = '2'"], # System group
                          :order => "groups.name")

  end

  def index
    list
    render :action => 'list'
  end

  def list
    @article_pages, @articles = paginate :articles, :per_page => 10
  end

  def show
    @article = Article.find(params[:id])
  end

  def new
    @article = Article.new
#    groups_select()
    articles()
  end

  def edit
    @article = Article.find(params[:id])
    @table = @article
    creator() # In application.rb, uses @table
    updater() # In application.rb, uses @table
#    groups_select()
    articles()
  end

  def create
    @article = Article.new(params[:article])
    @article.created_of = session[:noruser]
    @article.un_published = 0
    @articlegroup = ArticleGroup.new
    if @article.save
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
  end

  def update
    @article = Article.find(params[:id])
    @article.updated_of = session[:noruser]
    @articlegroup = ArticleGroup.new
    if @article.update_attributes(params[:article])
      @article.article_groups.clear
      params[:group].each { |x|  # Array created of chexboxes
        @article.article_groups << ArticleGroup.new(
                                                    :article_id   => params[:id],
                                                    :group_id => x.first
                                                    )
      }
      #      @first.clear
      flash[:notice] = 'Article was successfully updated.'
      redirect_to :action => 'show', :id => @article
    else
      render :action => 'edit'
    end
  end

  def clear_item
    @article = Article.find(params[:id])
    item = Item.new('tekst')
    item.destroy
    #    render(:partial => "/shared/item", :object => item, :layout => false)
    redirect_to :action => 'edit', :id => @article
  end
  def destroy
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
end
