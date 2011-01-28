class ReviewFormPossibleAnswersController < ApplicationController
  
  before_filter :require_login
  before_filter :load_context
  
  def load_context
    @user = User.find(params[:user_id])
    @project = Project.find(params[:project_id])
    @review_stage = @project.review_stages.find(params[:review_stage_id])
    @review_form = @review_stage.form
    @question = @review_form.questions.find(params[:review_form_question_id])
  end
  private :load_context

  def new
    @possible_answer = @question.possible_answers.create( :possible_answer => 'new answer' )
    
    respond_to do |format|
      format.html { render :partial => 'review_forms/possible_answer', :locals => { :possible_answer => @possible_answer } }
      format.xml  { render :xml => @possible_answer }
    end
  end

  def update
    @possible_answer = @question.possible_answers.find(params[:id])
    
    @possible_answer.update_attributes( params[:review_form_possible_answer] )
    
    if request.xhr?
      render :nothing => true
    else
      respond_to do |format|
        format.html { render :partial => 'review_forms/possible_answer', :locals => { :possible_answer => @possible_answer } }
        format.xml  { render :xml => @possible_answer }
      end
    end
  end

  def update_attribute
    @possible_answer = @question.possible_answers.find(params[:id])
    
    @possible_answer.send( "#{params[:attribute]}=", params[:value] ) ;
    @possible_answer.save
    
    if request.xhr?
      render :text => @possible_answer.send(params[:attribute])
    else
      respond_to do |format|
        format.html { render :partial => 'review_forms/possible_answer', :locals => { :possible_answer => @possible_answer } }
        format.xml  { render :xml => @possible_answer }
      end
    end
  end

  def sort
    @possible_answers = params["question-#{@question.id}-possible-answers"].reject(&:blank?).collect { |aid| @question.possible_answers.find(aid) }
    
    ReviewFormPossibleAnswer.transaction do
      @possible_answers.each_with_index do |possible_answer,index|
        possible_answer.update_attributes( :sequence => -1-index )
      end

      @possible_answers.each do |possible_answer|
        possible_answer.update_attributes( :sequence => -possible_answer.sequence )
      end
    
    end

    if request.xhr?
      render :nothing => true
    else
      respond_to do |format|
        format.html { render :action => :index }
        format.xml  { render :xml => @possible_answers }
      end
    end

  end

  def destroy
    @possible_answer = @question.possible_answers.find(params[:id])
    @possible_answer.destroy

    respond_to do |format|
      format.html { render :nothing => true }
      format.xml  { head :ok }
    end
  end

end