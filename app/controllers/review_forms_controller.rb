class ReviewFormsController < ApplicationController
  
  before_filter :require_login
  before_filter :load_context
  
  def load_context
    @user = User.find(params[:user_id])
    @project = Project.find(params[:project_id])
    @review_stage = @project.review_stages.find(params[:review_stage_id])
  end
  private :load_context
  
  def show
    @review_form = @review_stage.form

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @review_form }
    end
  end
  
  def new
    @review_form = @review_stage.build_form()

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @review_form }
    end
  end

  def create
    @review_form = @review_stage.build_form(params['review_form'])
    
    respond_to do |format|
      if @review_form.save
        flash[:notice] = 'Questionnaire was successfully created.'
        format.html { redirect_to(user_project_review_stage_review_form_url(@user,@project,@review_stage)) }
        format.xml  { render :xml => @review_form, :status => :created, :location => @review_stage }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @review_form.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def edit
    @review_form = @review_stage.form

    respond_to do |format|
      format.html # edit.html.erb
      format.xml  { render :xml => @review_form }
    end
  end

  def update
    @review_form = @review_stage.form
    @review_form.update_attributes(params['review_form'])
    
    respond_to do |format|
      if @review_form.save
        flash[:notice] = 'Questionnaire was successfully updated.'
        format.html { redirect_to(user_project_review_stage_review_form_url(@user,@project,@review_stage)) }
        format.xml  { render :xml => @review_form, :status => :created, :location => @review_stage }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @review_form.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @review_form = @review_stage.form
    @review_form.destroy

    respond_to do |format|
      format.html { redirect_to([@user,@project,@review_stage]) }
      format.xml  { head :ok }
    end
  end

end
