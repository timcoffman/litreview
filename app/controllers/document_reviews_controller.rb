class DocumentReviewsController < ApplicationController
  
  before_filter :require_login
  before_filter :load_context

  def load_context
    @user = User.find( params[:user_id] )
    @project = Project.find( params[:project_id] )
    @review_stage = @project.review_stages.find( params[:review_stage_id] )
    @stage_reviewer = @review_stage.stage_reviewers.find( params[:stage_reviewer_id] ) if params[:stage_reviewer_id]
    @reason = @review_stage.reasons.find( params[:reason] ) if params[:reason] 
  end
  private :load_context
  
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
  def add_reason
    @document_review = @stage_reviewer.document_reviews.find(params[:id])
    @reason = @document_review.stage_reviewer.custom_reasons.create( params[:custom_reason] )

    respond_to do |format|
      format.html { render :partial => 'reason', :locals => { :reason => @reason, :document_review => @document_review } }
      format.xml  { render :xml => @reason }
    end
  end
    
  # GET /document_reviews/1
  # GET /document_reviews/1.xml
  def show
    @document_review = @stage_reviewer.document_reviews.find(params[:id], :include => :reasons)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @document_review }
    end
  end

  # GET /document_reviews/new
  # GET /document_reviews/new.xml
  def new
    @document_review = @stage_reviewer.document_reviews.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @document_review }
    end
  end

  # GET /document_reviews/1/edit
  def edit
    @document_review = @stage_reviewer.document_reviews.find(params[:id], :include => :reasons)
  end

  # POST /document_reviews
  # POST /document_reviews.xml
  def create
    @document_review = @stage_reviewer.document_reviews.new(params[:document_review])

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
    @document_review = @stage_reviewer.document_reviews.find(params[:id])

    respond_to do |format|
      if @document_review.update_attributes(params[:document_review].reject { |k,v| k == 'reasons' })
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
    @document_review = @stage_reviewer.document_reviews.find(params[:id])
    @document_review.destroy

    respond_to do |format|
      format.html { redirect_to([@user,@project,@review_stage,@stage_reviewer]) }
      format.xml  { head :ok }
    end
  end
  
end
