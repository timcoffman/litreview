class ReviewFormAnswersController < ApplicationController

  before_filter :require_login
  before_filter :load_context

  def load_context
    @user = User.find( params[:user_id] )
    @project = Project.find( params[:project_id] )
    @review_stage = @project.review_stages.find( params[:review_stage_id] )
    @stage_reviewer = @review_stage.stage_reviewers.find( params[:stage_reviewer_id] )
    @document_review = @stage_reviewer.document_reviews.find( params[:document_review_id] )
  end
  private :load_context

  def create
    @review_form_answer = @document_review.form_answers.build( params[:review_form_answer] )
    
    respond_to do |format|
      if @review_form_answer.save
        flash[:notice] = 'ReviewFormAnswer was successfully created.'
        format.html { redirect_to([@user,@project,@review_stage,@stage_reviewer,@document_review]) }
        format.xml  { render :xml => @review_form_answer, :status => :created, :location => @review_form_answer }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @review_form_answer.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @review_form_answer = @document_review.form_answers.find( params[:id] )
    @review_form_answer.destroy

    respond_to do |format|
      flash[:notice] = 'ReviewFormAnswer was successfully deleted.'
      format.html { redirect_to([@user,@project,@review_stage,@stage_reviewer,@document_review]) }
      format.xml  { head :ok }
    end
  end
  
  def retract
    @review_form_answers = @document_review.form_answers.find( :all, :conditions => params[:review_form_answer] )
    ReviewFormAnswer.transaction do
      @review_form_answers.each(&:destroy)
    end

    respond_to do |format|
      flash[:notice] = 'ReviewFormAnswers were successfully deleted.'
      format.html { redirect_to([@user,@project,@review_stage,@stage_reviewer,@document_review]) }
      format.xml  { head :ok }
    end
  end
  
end
