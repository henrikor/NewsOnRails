# -*- encoding : utf-8 -*-
class AdminController < ApplicationController
    include NorAuthorize
  #  include AuthenticatedSystem

  before_filter :nor_logged_in?
  before_filter :klargjor
  before_filter :left_column
  #  permit "Admin", :except => :index
  #  permit "Admin or RoleAdmin or UserAdmin"
  before_filter :nor_authorized?
  
  def index
    userlist
    render :action => 'userlist'
  end

  def dashboard
    @types = {1 => 'Link', 2 => 'Dropdown', 3 => 'Custom'}
    @menu_elements = MenuElement.all
  end

  def new_menu_element
    @menu_element = MenuElement.new
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
    :redirect_to => { :action => :list }
  
  def list
    @not_show = ["Salt", "token", "Crypted password", "Remember token", "Remember token expires at"]

    if params[:sort]
      @sort = params[:sort]
    else
      @sort = "name"
    end

    if params[:order]
      @order = params[:order]
    else
      @order = "desc"
    end

    #    @psort = @sort
    if @sort != "name"
      sort = "#{@sort} #{@order}, login desc"
    else
      sort = "#{@sort} #{@order}"
    end

    @porder = @order

    @stylesheet = "admin"
#    @role_pages, @roles = paginate(:Roles, :order => sort, :per_page => 10)
    @roles = Role.paginate :page => params[:page], :order => sort
    @admin = @roles


    if @order == "asc"
      @order = "desc"
    else
      @order = "asc"
    end
      
    #  @role_pages, @roles = paginate :roles, :per_page => 10

    #    flash[:notice] = "TEST #{@curretn_noruser}" # ||= (session[:noruser])
    #    flash[:notice] = "TEST #{session[:noruser]}" # ||= (session[:noruser])
  end

  def show
    @role = Role.find(params[:id])
  end

  def new
    @role = Role.new
  end

  def create
    @role = Role.new(params[:role])
    if @role.save
      flash[:notice] = 'Role was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @role = Role.find(params[:id])
  end

  def update
    @role = Role.find(params[:id])
    if @role.update_attributes(params[:role])
      flash[:notice] = 'Role was successfully updated.'
      redirect_to :action => 'show', :id => @role
    else
      render :action => 'edit'
    end
  end
  def destroy
    Role.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  ###############################
  #   BRUKER ADMINISTRERTING:   #
  ###############################
  
  def usershow
    @user = Noruser.find(params[:id])
  end

  def userlist
    @not_show = ["Salt", "token", "Crypted password", "Remember token", "Remember token expires at"]

    if params[:sort]
      @sort = params[:sort]
    else
      @sort = "login"
    end

    if params[:order]
      @order = params[:order]
    else
      @order = "desc"
    end

    #    @psort = @sort
    if @sort != "login"
      sort = "#{@sort} #{@order}, login desc"
    else
      sort = "#{@sort} #{@order}"
    end

    @porder = @order

    @stylesheet = "admin"
#    @user_pages, @users = paginate(:Norusers, :order => sort, :per_page => 10)
    @users = Noruser.paginate :page => params[:page], :order => sort
    @admin = @users

    if @order == "asc"
      @order = "desc"
    else
      @order = "asc"
    end
  end
  
  def useredit
    @user = Noruser.find(params[:id])
#    @roles = Role.find(:all)
    @roles = Role.all
  end

  def usernyttpass
    @user = Noruser.find(params[:id])
#    @user = Noruser.find(86)


    raise if @user.nil?
    return if @user unless params[:user]
#    if (params[:password] == params[:password_confirmation])

	pw = params[:user][:password]      
      self.current_user = @user #for the next two lines to work
      current_user.password_confirmation = pw
      current_user.password = pw
      @user.reset_password
      flash[:notice] = current_user.save ? "Password reset" : "Password not reset" 
      redirect_to :action => 'useredit', :id => @user

 #   else
 #     flash[:notice] = "Passordene stemte ikke med hverandre" 
 #   end


#    self.current_user = @user
#    current_user.password = params[:password]
#    @user.reset_password
#    @user.save!


#params.require(:cart).permit(:attribute1, :attribute2, :attribute3)
#    if @user.update_attributes(params[:user])
 #reset_password
#    if @user.update_attributes(admin_params)
#      flash[:notice] = 'user was successfully updated.'
#      redirect_to :action => 'usershow', :id => @user
#    else
#      flash[:error] = 'Error - password not updated!'
#    end


  end
  def userupdate
    @user = Noruser.find(params[:id])
    @user.roles = Role.find(params[:roller]) if params[:roller] #legger inn fra checkbokser

    if @user.update_attributes(admin_params)
      flash[:notice] = 'user was successfully updated.'
      redirect_to :action => 'usershow', :id => @user
    else
      render :action => 'useredit'
    end
  end
  
  def userdestroy
    Noruser.find(params[:id]).destroy
    redirect_to :action => 'userlist'
  end
  def admin_params
    params.require(:user).permit(:login, :passwd, :password, :email, :updated_at, :users, :roller, :id)
  end

end
