class ManagersController < ApplicationController
  # GET /managers
  # GET /managers.xml
  def index
	@user = User.find(params[:user_id])
	@project = Project.find(params[:project_id])
	@managers = @project.managers.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @managers }
    end
  end

  # GET /managers/1
  # GET /managers/1.xml
  def show
    @user = User.find(params[:user_id])
    @project = Project.find(params[:project_id])
    @manager = Manager.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @manager }
    end
  end

  # GET /managers/new
  # GET /managers/new.xml
  def new
    @user = User.find(params[:user_id])
    @project = Project.find(params[:project_id])
    @manager = Manager.new( :project_id => @project.id, :user_id => @user.id )
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @manager }
    end
  end

  # GET /managers/1/edit
  def edit
    @user = User.find(params[:user_id])
    @project = Project.find(params[:project_id])
    @manager = Manager.find(params[:id])
  end

  # POST /managers
  # POST /managers.xml
  def create
    @user = User.find(params[:user_id])
    @project = Project.find(params[:project_id])
    @manager = Manager.new(params[:manager])

    respond_to do |format|
      if @manager.save
        flash[:notice] = 'Manager was successfully created.'
        format.html { redirect_to([@user,@project]) }
        format.xml  { render :xml => @manager, :status => :created, :location => @manager }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @manager.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /managers/1
  # PUT /managers/1.xml
  def update
    @user = User.find(params[:user_id])
    @project = Project.find(params[:project_id])
    @manager = Manager.find(params[:id])

    respond_to do |format|
      if @manager.update_attributes(params[:manager])
        flash[:notice] = 'Manager was successfully updated.'
        format.html { redirect_to([@user,@project,@manager]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @manager.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /managers/1
  # DELETE /managers/1.xml
  def destroy
    @user = User.find(params[:user_id])
    @project = Project.find(params[:project_id])
    @manager = Manager.find(params[:id])
    @manager.destroy

    respond_to do |format|
      format.html { redirect_to([@user,@project]) }
      format.xml  { head :ok }
    end
  end
end
