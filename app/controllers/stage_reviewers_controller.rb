class StageReviewersController < ApplicationController
  # GET /stage_reviewers
  # GET /stage_reviewers.xml
  def index
    @user = User.find(params[:user_id])
    @project = Project.find(params[:project_id])
    @review_stage = ReviewStage.find(params[:review_stage_id])
    @stage_reviewers = StageReviewer.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @stage_reviewers }
    end
  end

  # GET /stage_reviewers/1
  # GET /stage_reviewers/1.xml
  def show
    @user = User.find(params[:user_id])
    @project = Project.find(params[:project_id])
    @review_stage = ReviewStage.find(params[:review_stage_id])
    @stage_reviewer = StageReviewer.find(params[:id])
	@incomplete_reviews = @stage_reviewer.incomplete_reviews.find(:all, :limit => 10 )
	@completed_reviews = @stage_reviewer.completed_reviews.find(:all, :limit => 10 )

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @stage_reviewer }
    end
  end

  # GET /stage_reviewers/new
  # GET /stage_reviewers/new.xml
  def new
    @user = User.find(params[:user_id])
    @project = Project.find(params[:project_id])
    @review_stage = ReviewStage.find(params[:review_stage_id])
    @stage_reviewer = @review_stage.stage_reviewers.build( params[:stage_reviewer] )

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @stage_reviewer }
    end
  end

  # GET /stage_reviewers/1/edit
  def edit
    @user = User.find(params[:user_id])
    @project = Project.find(params[:project_id])
    @review_stage = ReviewStage.find(params[:review_stage_id])
    @stage_reviewer = StageReviewer.find(params[:id])
  end

  # POST /stage_reviewers
  # POST /stage_reviewers.xml
  def create
    @user = User.find(params[:user_id])
    @project = Project.find(params[:project_id])
    @review_stage = ReviewStage.find(params[:review_stage_id])
    @stage_reviewer = StageReviewer.new(params[:stage_reviewer])

    respond_to do |format|
      if @stage_reviewer.save
        flash[:notice] = 'StageReviewer was successfully created.'
        format.html { redirect_to([@user,@project,@review_stage,@stage_reviewer]) }
        format.xml  { render :xml => @stage_reviewer, :status => :created, :location => @stage_reviewer }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @stage_reviewer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /stage_reviewers/1
  # PUT /stage_reviewers/1.xml
  def update
    @user = User.find(params[:user_id])
    @project = Project.find(params[:project_id])
    @review_stage = ReviewStage.find(params[:review_stage_id])
    @stage_reviewer = StageReviewer.find(params[:id])

    respond_to do |format|
      if @stage_reviewer.update_attributes(params[:stage_reviewer])
        flash[:notice] = 'StageReviewer was successfully updated.'
        format.html { redirect_to([@user,@project,@review_stage,@stage_reviewer]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @stage_reviewer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /stage_reviewers/1
  # DELETE /stage_reviewers/1.xml
  def destroy
    @user = User.find(params[:user_id])
    @project = Project.find(params[:project_id])
    @review_stage = ReviewStage.find(params[:review_stage_id])
    @stage_reviewer = StageReviewer.find(params[:id])
    @stage_reviewer.destroy

    respond_to do |format|
      format.html { redirect_to([@user,@project,@review_stage]) }
      format.xml  { head :ok }
    end
  end
end
