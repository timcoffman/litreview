class ReasonsController < ApplicationController
  before_filter :require_login
  
  before_filter { |controller| controller.load_context }

  def load_context
    @user = User.find( params[:user_id] )
    @project = Project.find( params[:project_id] )
    @review_stage = ReviewStage.find( params[:review_stage_id] )
  end
  
  def index
    @reasons = @review_stage.reasons.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @reasons }
    end
  end

  def sort
    @reasons = params['reasons-list'].reject(&:blank?).collect { |rid| @review_stage.reasons.find(rid) }
    
    Reason.transaction do
      @reasons.each_with_index do |reason,index|
        reason.update_attributes( :sequence => -1-index )
      end

      @reasons.each do |reason|
        reason.update_attributes( :sequence => -reason.sequence )
      end
    
    end

    if request.xhr?
      render :nothing => true
    else
      respond_to do |format|
        format.html { render :action => :index }
        format.xml  { render :xml => @reasons }
      end
    end

  end

  def show
    @reason = @review_stage.reasons.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @reason }
    end
  end

  # GET /reasons/new
  # GET /reasons/new.xml
  def new
    @reason = @review_stage.reasons.build(:title=>"New Reason for Exclusion" )

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @reason }
    end
  end

  # GET /reasons/1/edit
  def edit
    @reason = @review_stage.reasons.find(params[:id])
  end

  # POST /reasons
  # POST /reasons.xml
  def create
    @reason = @review_stage.reasons.build(params[:reason])

    respond_to do |format|
      if @reason.save
        flash[:notice] = 'Reason was successfully created.'
        format.html { redirect_to([@user,@project,@review_stage,@reason]) }
        format.xml  { render :xml => @reason, :status => :created, :location => @reason }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @reason.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /reasons/1
  # PUT /reasons/1.xml
  def update
    @reason = Reason.find(params[:id])

    respond_to do |format|
      if @reason.update_attributes(params[:reason])
        flash[:notice] = 'Reason was successfully updated.'
        format.html { redirect_to([@user,@project,@review_stage,@reason]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @reason.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /reasons/1
  # DELETE /reasons/1.xml
  def destroy
    @reason = Reason.find(params[:id])
    @reason.destroy

    respond_to do |format|
      format.html { redirect_to(reasons_url) }
      format.xml  { head :ok }
    end
  end
end
