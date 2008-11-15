class ReviewStagesController < ApplicationController
  # GET /review_stages
  # GET /review_stages.xml
  def index
    @user = User.find(params[:user_id])
    @project = Project.find( params[:project_id] )
    @review_stages = @project.review_stages

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @review_stages }
    end
  end

  # GET /review_stages/1
  # GET /review_stages/1.xml
  def show
    @user = User.find(params[:user_id])
    @project = Project.find( params[:project_id] )
    @review_stage = ReviewStage.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @review_stage }
    end
  end

  # GET /review_stages/new
  # GET /review_stages/new.xml
  def new
    @user = User.find(params[:user_id])
    @project = Project.find( params[:project_id] )
    @review_stage = @project.review_stages.build( :sequence => @project.review_stages.collect { |rs| rs.sequence }.max )

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @review_stage }
    end
  end

  # GET /review_stages/1/edit
  def edit
    @user = User.find(params[:user_id])
    @project = Project.find( params[:project_id] )
    @review_stage = ReviewStage.find(params[:id])
  end

  # POST /review_stages
  # POST /review_stages.xml
  def create
    @user = User.find(params[:user_id])
    @project = Project.find( params[:project_id] )
    @review_stage = ReviewStage.new(params[:review_stage])

    respond_to do |format|
      if @review_stage.save
        flash[:notice] = 'ReviewStage was successfully created.'
        format.html { redirect_to( [@user,@review_stage.project,@review_stage] ) }
        format.xml  { render :xml => @review_stage, :status => :created, :location => @review_stage }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @review_stage.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /review_stages/1
  # PUT /review_stages/1.xml
  def update
    @user = User.find(params[:user_id])
    @project = Project.find( params[:project_id] )
    @review_stage = ReviewStage.find(params[:id])

    respond_to do |format|
      if @review_stage.update_attributes(params[:review_stage])
        flash[:notice] = 'ReviewStage was successfully updated.'
        format.html { redirect_to( [@user,@project,@review_stage] ) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @review_stage.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /review_stages/1
  # DELETE /review_stages/1.xml
  def destroy
    @user = User.find(params[:user_id])
    @project = Project.find( params[:project_id] )
    @review_stage = ReviewStage.find(params[:id])
    @review_stage.destroy

    respond_to do |format|
      format.html { redirect_to( [@user,@project] ) }
      format.xml  { head :ok }
    end
  end

  def report
    @user = User.find( params[:user_id] )
    @project = Project.find(params[:project_id])
    @review_stage = ReviewStage.find(params[:id])
    @report = @review_stage.new_report( { :groups => [ 'Agreement' ] }.merge( params[:report] || {} ) )
    respond_to do |format|
      format.html
      format.xml { render :xml => @report }
    end
  end
end
