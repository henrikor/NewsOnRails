# -*- encoding : utf-8 -*-
class LagController < StartController
  #include ApplicationHelper
#  caches_page :index

  # ATOM HELPER:
  # http://svn.rubyonrails.org/rails/plugins/atom_feed_helper/README
  
  def no_lag(lag = params[:lag], id = params[:id], page = params[:page], controller = "lag")
    id = 10 unless id
    if lag
      lag2 = Group.group_from_name(lag)
      if !lag2
        flash[:error] = "Siden: \"#{lag}\" finnes ikke"
        lag2 = Group.find(8)
        redirect_to "/finnes_ikke"
        return
      end
      @lagid = lag2.id
    end
    @lagid = params[:lagid] if params[:lagid]
    @lagid = 8 unless @lagid
    result = GroupGroup.find(:first,  # Check that the group are in the lag group
      :conditions => "group_id = '#{@lagid}' and group_id2 = '4'")
    begin
      raise "Invalid group" if !result
    rescue
      lag = @lagid unless lag
      group()
    end
    if result
      if lag
        @lag = lag
      else
        lagtmp = Group.find(@lagid)
        @lag = lagtmp.name
      end
      group(id, @lagid, params[:page])
    end
  end

  # ----------------------------------------------------------------------------
  # This action is used by all localgroups ("lag") that dosn't have theire
  # owne action. All url's with no given controller or action is handeled here.
  # "lag" is btw. just an norwegian word for "localgroup" :-).
  # ----------------------------------------------------------------------------

  def lag_old(lag = params[:lag], id = params[:id], page = params[:page], controller = "lag")
    if lag && methods.include?(lag)
      redirect_to :action => lag
    elsif defined?(lag)
      no_lag(lag, id, page, controller)
    elsif id
      lag = Group.find(id)
      no_lag(lag.name, "10", page, controller)
    else
      flash[:notice] = "Wrong lag??"
      redirect_to :action => "index"
    end
  end

  def index(lag = params[:lag], id = params[:id], page = params[:page], controller = "lag")
    @page = page
    @right_column = 1
    group = Group.find(id)
    @description = group.description
    @groupname = group.name
    norinitialize()
    @groupid = id
    @action_nor = "index" # used by start/_link.rhtml
    if defined?(lag)
      no_lag(lag, id, page, controller)
    elsif id
      lag = Group.find(id)
      no_lag(lag.name, "10", page, controller)
    else
      flash[:notice] = "Wrong lag??"
      #      redirect_to :action => "index"
      no_lag("Sentralt", "10", page, controller)     
    end
  end

  def index_old(id = params[:id], page = params[:page], controller = "lag") # Central page. Is routed here by default.
    @action_nor = "index"
    @lag = "index"
    if !id     # 10 = frontpage, 8 = au
      id = 10
      #session[:lag] = 8
    end
    group(id, 8, params[:page])
  end


  #  def asker(id = params[:id], page = params[:page], controller = "lag") # Central page. Is routed here by default.
  #    @action_nor = "asker"
  #    if !id     # 10 = frontpage, 8 = au
  #      id = 10
  #    end
  #    group(id, 32, params[:page])
  #  end


end
