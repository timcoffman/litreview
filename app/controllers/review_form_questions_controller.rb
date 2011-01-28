class ReviewFormQuestionsController < ApplicationController
  
  before_filter :require_login
  before_filter :load_context
  
  def load_context
    @user = User.find(params[:user_id])
    @project = Project.find(params[:project_id])
    @review_stage = @project.review_stages.find(params[:review_stage_id])
    @review_form = @review_stage.form
  end
  private :load_context

  def new
    @question = @review_form.questions.create( :question => 'new question' )
    
    respond_to do |format|
      format.html { render :partial => 'review_forms/question', :locals => { :question => @question } }
      format.xml  { render :xml => @question }
    end
  end

  def update
    @question = @review_form.questions.find(params[:id])
    
    @question.update_attributes( params[:review_form_question] )
    
    if request.xhr?
      render :nothing => true
    else
      respond_to do |format|
      format.html { render :partial => 'review_forms/question', :locals => { :question => @question } }
        format.xml  { render :xml => @questions }
      end
    end
  end

  def update_attribute
    @question = @review_form.questions.find(params[:id])
    
    @question.send( "#{params[:attribute]}=", params[:value] ) ;
    @question.save
    
    if request.xhr?
      render :text => @question.send(params[:attribute])
    else
      respond_to do |format|
      format.html { render :partial => 'review_forms/question', :locals => { :question => @question } }
        format.xml  { render :xml => @questions }
      end
    end
  end

  def sort
    @questions = params['question-list'].reject(&:blank?).collect { |qid| @review_form.questions.find(qid) }
    
    ReviewFormQuestion.transaction do
      @questions.each_with_index do |question,index|
        question.update_attributes( :sequence => -1-index )
      end

      @questions.each do |question|
        question.update_attributes( :sequence => -question.sequence )
      end
    
    end
    
    if request.xhr?
      render :nothing => true
    else
      respond_to do |format|
        format.html { render :action => :index }
        format.xml  { render :xml => @questions }
      end
    end

  end

  def destroy
    @question = @review_form.questions.find(params[:id])
    @question.destroy

    respond_to do |format|
      format.html { render :nothing => true }
      format.xml  { head :ok }
    end
  end

end
