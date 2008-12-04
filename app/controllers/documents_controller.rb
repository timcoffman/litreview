class DocumentsController < ApplicationController
  # GET /documents
  # GET /documents.xml
  def index
	@user = User.find(params[:user_id])
	@project = Project.find(params[:project_id])
	@limit = params[:limit] || 10
	@limit = @limit.to_i
	@offset = params[:offset] || 0
	@offset = @offset.to_i
    @documents = @project.documents.find(:all,:limit => @limit, :offset => @offset, :include => :document_source )
    @document_count = @project.documents.count(:all)
	@page = ( @offset / @limit ).floor
	@pages = ( @document_count / @limit ).ceil

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @documents }
    end
  end

  # GET /documents/1
  # GET /documents/1.xml
  def show
	@user = User.find(params[:user_id])
	@project = Project.find(params[:project_id])
    @document = Document.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @document }
    end
  end

  # GET /documents/new
  # GET /documents/new.xml
  def new
	@user = User.find(params[:user_id])
	@project = Project.find(params[:project_id])
    @document = Document.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @document }
    end
  end

  # GET /documents/1/edit
  def edit
	@user = User.find(params[:user_id])
	@project = Project.find(params[:project_id])
    @document = Document.find(params[:id])
  end

  # POST /documents
  # POST /documents.xml
  def create
	@user = User.find(params[:user_id])
	@project = Project.find(params[:project_id])
    @document = Document.new(params[:document])

    respond_to do |format|
      if @document.save
        flash[:notice] = 'Document was successfully created.'
        format.html { redirect_to([@user,@project,@document]) }
        format.xml  { render :xml => @document, :status => :created, :location => @document }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @document.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /documents/1
  # PUT /documents/1.xml
  def update
	@user = User.find(params[:user_id])
	@project = Project.find(params[:project_id])
    @document = Document.find(params[:id])

    respond_to do |format|
      if @document.update_attributes(params[:document])
        flash[:notice] = 'Document was successfully updated.'
        format.html { redirect_to([@user,@project,@document]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @document.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /documents/1
  # DELETE /documents/1.xml
  def destroy
	@user = User.find(params[:user_id])
	@project = Project.find(params[:project_id])
    @document = Document.find(params[:id])
    @document.destroy

    respond_to do |format|
      format.html { redirect_to([@user,@project]) }
      format.xml  { head :ok }
    end
  end
  
  def match_duplicates
	@user = User.find(params[:user_id])
	@project = Project.find(params[:project_id])
    @document = Document.find(params[:id])

    respond_to do |format|
      format.html # match_duplicates.html.erb
      format.xml  { render :xml => @document }
    end
  end
end
