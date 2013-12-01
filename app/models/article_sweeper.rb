# -*- encoding : utf-8 -*-
class ArticleSweeper < ActionController::Caching::Sweeper
  require 'fileutils'
  include FileUtils::Verbose

  observe Article
  # If we create a new article, the public list
  # of articles must be regenerated
  def after_create(article)
    #expire_public_page(params[:article], params[:group])
    '/etc/cron.hourly/railsfix'
  end
  # If we update an existing article, the cached version
  # of that particular article becomes stale
  def after_update(article)
    #expire_public_page(params[:article], params[:group])
    '/etc/cron.hourly/railsfix'
  end
  # Deleting a page means we update the public list
  # and blow away the cached article
  def after_destroy_old(article)
    #expire_public_pageold(article)
    '/etc/cron.hourly/railsfix'
  end

#  private

#  def expire_public_page(article, group = 10)
#    expire_page(:controller => "start" , :action => 'view', :id => article.id )
#
#    group.each{ |x|
#      #expire_page(:controller => "lag" , :action => 'index' )
#      result = GroupGroup.find(:first,  # Check that the group are in the lag group
#                               :conditions => "group_id = '#{x.first}' and group_id2 = '4'")
#      if result
#        lag = Group.find(x.first)
#        # If we are caching lag without own action:
#        expire_page(:controller => "lag" , :action => 'index', :lag => lag.name )
#        # else, if lag has own action:
#        # expire_page(:controller => "lag" , :action => lag.name )
#        # Expire all temes (groups) pages for this lag:
#        group.each{ |y|
#          expire_page(:controller => "lag" , :action => "index", :id => y.first )
#          expire_page(:controller => "lag" , :action => "index", :lag => lag.name, :id => y.first )
#
#          # Slett index.html på root nivå / Ikke gjør noe med sentralt. Det gjør vi via cron:
#          if (lag.id == 8)# && (y.first == '10')
#            #next # slett vi cron
#            expire_page(:controller => "index", :action => nil) #Vi sletter her
#          end
#
#          # Slett "bliaktiv"
#          if y.first == '123'
#            expire_page(:controller => "index" , :action => 'bliaktiv')
#          end
#
##          touch("../test_fil_xx")
#
#    begin
#
#    if defined?(lag.name) && defined?(y) && File.exist?("../www-public/#{lag.name}/#{y.first}")
#            begin
#              rm_rf("../www-public/#{lag.name}/#{y.first}")
#            rescue
#              flash[:error] = "Klarte ikke aa slette ../www-public/#{lag.name}/#{y.first}"
#            end
#    end
#
#
#          expire_page(:controller => "lag" , :action => "index", :lag => lag.name, :id => y.first, :page => "index")
#
##          pagedir_tmp = url_for(:controller => "lag" , :action => "index", :lag => "Sentralt", :id => "36" )
##          pagedir = pagedir_tmp.sub(/\//, 'www-public')
##          rm_rf(pagedir)
##          touch("www-public/railstest")
##        }
#
#      else
#        expire_page(:controller => "lag" , :action => 'index', :id => x.first )
#
#      end
#    }
end
