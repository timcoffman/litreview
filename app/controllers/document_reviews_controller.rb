class DocumentReviewsController < ApplicationController
  
  before_filter { |controller| controller.load_context }

  def load_context
    @user = User.find( params[:user_id] )
    @project = Project.find( params[:project_id] )
    @review_stage = @project.review_stages.find( params[:review_stage_id] )
    @stage_reviewer = @review_stage.stage_reviewers.find( params[:stage_reviewer_id] ) if params[:stage_reviewer_id]
    @reason = @review_stage.reasons.find( params[:reason] ) if params[:reason] 
  end
  
  def index
    if @reason
      conditions = {}
      conditions[:stage_reviewer_id] = @stage_reviewer.id if @stage_reviewer
      @document_reviews = @reason.document_reviews.find(:all, :conditions => conditions, :limit => 20)
    else
      @document_reviews = (@stage_reviewer || @review_stage).document_reviews.find(:all, :conditions => conditions,  :limit => 20)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @document_reviews }
    end
  end
  
  # GET /document_reviews/1/new_reason
  # GET /document_reviews/1.xml
  def new_reason
    @user = User.find(params[:user_id])
    @project = Project.find(params[:project_id])
    @review_stage = ReviewStage.find(params[:review_stage_id])
    @document_review = DocumentReview.find(params[:id])
	@reason = @document_review.stage_reviewer.custom_reasons.build( :title => 'new reason' )

    respond_to do |format|
      format.html { render :layout => false } # new_reason.html.erb
      format.xml  { render :xml => @reason }
    end
  end
    
  # GET /document_reviews/1
  # GET /document_reviews/1.xml
  def show
    @user = User.find(params[:user_id])
    @project = Project.find(params[:project_id])
    @review_stage = ReviewStage.find(params[:review_stage_id])
    @stage_reviewer = StageReviewer.find(params[:stage_reviewer_id])
    @document_review = DocumentReview.find(params[:id], :include => :reasons)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @document_review }
    end
  end

  # GET /document_reviews/new
  # GET /document_reviews/new.xml
  def new
    @user = User.find(params[:user_id])
    @project = Project.find(params[:project_id])
    @review_stage = ReviewStage.find(params[:review_stage_id])
    @stage_reviewer = StageReviewer.find(params[:stage_reviewer_id])
    @document_review = DocumentReview.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @document_review }
    end
  end

  # GET /document_reviews/1/edit
  def edit
    @user = User.find(params[:user_id])
    @project = Project.find(params[:project_id])
    @review_stage = ReviewStage.find(params[:review_stage_id])
    @stage_reviewer = StageReviewer.find(params[:stage_reviewer_id])
    @document_review = DocumentReview.find(params[:id], :include => :reasons)
  end

  # POST /document_reviews
  # POST /document_reviews.xml
  def create
    @user = User.find(params[:user_id])
    @project = Project.find(params[:project_id])
    @review_stage = ReviewStage.find(params[:review_stage_id])
    @stage_reviewer = StageReviewer.find(params[:stage_reviewer_id])
    @document_review = DocumentReview.new(params[:document_review])

    respond_to do |format|
      if @document_review.save
        flash[:notice] = 'DocumentReview was successfully created.'
        format.html { redirect_to([@user,@project,@review_stage,@stage_reviewer,@document_review]) }
        format.xml  { render :xml => @document_review, :status => :created, :location => @document_review }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @document_review.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /document_reviews/1
  # PUT /document_reviews/1.xml
  def update
    @user = User.find(params[:user_id])
    @project = Project.find(params[:project_id])
    @review_stage = ReviewStage.find(params[:review_stage_id])
    @stage_reviewer = StageReviewer.find(params[:stage_reviewer_id])
    @document_review = DocumentReview.find(params[:id])

    respond_to do |format|
      if @document_review.update_attributes(params[:document_review])
        flash[:notice] = 'DocumentReview was successfully updated.'
        format.html { redirect_to([@user,@project,@review_stage,@stage_reviewer,@document_review]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @document_review.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /document_reviews/1
  # DELETE /document_reviews/1.xml
  def destroy
    @user = User.find(params[:user_id])
    @project = Project.find(params[:project_id])
    @review_stage = ReviewStage.find(params[:review_stage_id])
    @stage_reviewer = StageReviewer.find(params[:stage_reviewer_id])
    @document_review = DocumentReview.find(params[:id])
    @document_review.destroy

    respond_to do |format|
      format.html { redirect_to([@user,@project,@review_stage,@stage_reviewer]) }
      format.xml  { head :ok }
    end
  end
end
