class ProjectsController < ApplicationController

  before_filter :require_login
  #before_filter :require_admin_login

  def update_dashboard
	super
	@dashboard.headsup('Project').items << "HeadsUp item 1"
  end

  # GET /projects
  # GET /projects.xml
  def index
    @user = User.find( params[:user_id] )
	@user = current_user unless @user || current_user.is_admin?
	@project = current_project
    @projects = Project.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @projects }
    end
  end

  # GET /projects/1
  # GET /projects/1.xml
  def show
    @user = User.find( params[:user_id] )
    @project = Project.find(params[:id], :include => { :review_stages => :stage_reviewers } )

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @project }
    end
  end

  # GET /projects/new
  # GET /projects/new.xml
  def new
    @user = User.find( params[:user_id] )
    @project = Project.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @project }
    end
  end

  # GET /projects/1/edit
  def edit
    @user = User.find( params[:user_id] )
    @project = Project.find(params[:id])
  end

  # POST /projects
  # POST /projects.xml
  def create
    @user = User.find( params[:user_id] )
    @project = Project.new(params[:project])

    respond_to do |format|
      if @project.save
        flash[:notice] = 'Project was successfully created.'
        format.html { redirect_to([@user,@project]) }
        format.xml  { render :xml => @project, :status => :created, :location => @project }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.xml
  def update
    @user = User.find( params[:user_id] )
    @project = Project.find(params[:id])

    respond_to do |format|
      if @project.update_attributes(params[:project])
        flash[:notice] = 'Project was successfully updated.'
        format.html { redirect_to([@user,@project]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.xml
  def destroy
    @user = User.find( params[:user_id] )
    @project = Project.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to(projects_url) }
      format.xml  { head :ok }
    end
  end

  def report
    @user = User.find( params[:user_id] )
    @project = Project.find(params[:id])
    @report = @project.new_report( params[:report] )
    respond_to do |format|
      format.html
      format.xml { render :xml => @report }
    end
  end
    
  def invite_reviewer
    @user = User.find( params[:user_id] )
    @project = Project.find(params[:id])
	invitee_address = params[:invitee_address]
	
	Inviter.deliver_invitation( @user, @project, invitee_address )
	flash[:notice] = "#{invitee_address} invited to join #{@project.title}."

    respond_to do |format|
		format.html { redirect_to([@user,@project]) }
		format.xml { head :ok }
	end
  end
end
