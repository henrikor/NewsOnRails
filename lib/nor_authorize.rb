# -*- encoding : utf-8 -*-
# Methods added to this helper will be available to all templates in the application.
module NorAuthorize
  #  include AuthenticatedSystem

  def nor_logged_in?
    redirect_back_or_default(:controller => '/account', :action => 'index') unless logged_in? # || Noruser.count > 0 
    #        redirect_to("/account/login") unless logged_in? # || Noruser.count > 0
  end
  def user?
    !session[:noruser].nil?
  end
  
  def noruser
    if session && session[:noruser] && !session[:noruser].nil?
      noruser = Noruser.find(session[:noruser])
    else
      return false
    end
    
  end
  def member_of_role?(roleid)
    user = session[:noruser]
    usersroles = Role.find_by_sql(["SELECT DISTINCT noruser_id FROM norusers_roles WHERE noruser_id = '?'
                                    AND role_id = '?'", user, roleid])
    if usersroles && !usersroles.empty?
      return true
    end
    return false
  end

  def authorized_to?(accessarr)
    nor_authf(accessarr)
  end

  def nor_authorized?
    unless nor_authf(params)
      flash[:notice] = "Du har ikke tilgang til denne siden" 
      access_denied
    end
  end

  def nor_authf(accessarr)
    if logged_in?
      tekst = accessarr[:controller] =~ /(\w)(.*)/
      controller = $1.upcase + $2 + "Controller"      
      fil = YAML::load( File.open( "#{Rails.root}/config/autorized.yml") )
      
      if fil[controller][accessarr[:action]]
        access_text = fil[controller][accessarr[:action]] 
      else # Hvis yml er tom eller manglende for action, bruk rettighetene satt i index om mulig
        raise "finner ikke index action og gjeldende action == nil eller ikke eksisterende i authorized.yml" if !fil[controller]["index"]
        access_text = fil[controller]["index"]
      end
      
      return true if current_user.has_role?("Admin")
      return true if permit? access_text
    end
  end

  def autorized_to_article?(articleid = nil)
    if !articleid
      return true
    end
    article = Article.find(articleid)
    if (article.created_of == session[:noruser] && member_of_role?(article.owner)) || (member_of_role?(article.owner) && member_of_role?(17)) # role 17 == Redaktør
      return true
    else
      return false
    end
  end

  def autorized_to_group?(group, user = session[:noruser])
    sql = "SELECT DISTINCT gt.id FROM group_groups gt
                        JOIN groups g ON g.id = gt.group_id
                        JOIN group_roles gr ON g.id = gr.group_id
                        JOIN norusers_roles ur ON gr.role_id = ur.role_id
                        WHERE
                        gt.group_id2 = 4 # lag group. Ikke tull med denne
                        AND
                        gt.group_id = ?
                        AND
                        gr.role_id IN (SELECT role_id FROM norusers_roles WHERE noruser_id = ?)"  # Role writer_stab

    result = GroupGroup.find_by_sql([sql, group, user])
    if result && !result.empty?
      return true
    else
      return false
    end

    #    if GroupGroup.find_by_sql([sql, group, session[:noruser]])
    #      return 1
    #    else
    #      return null
    #    end
  end


end
