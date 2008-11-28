class DocumentSourcesController < ApplicationController
  # GET /document_sources
  # GET /document_sources.xml
  def index
	@user = User.find(params[:user_id])
	@project = Project.find(params[:project_id])
    @document_sources = @project.document_sources.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @document_sources }
    end
  end

  # GET /document_sources/1
  # GET /document_sources/1.xml
  def show
	@user = User.find(params[:user_id])
	@project = Project.find(params[:project_id])
    @document_source = @project.document_sources.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @document_source }
    end
  end

  # GET /document_sources/new
  # GET /document_sources/new.xml
  def new
	@user = User.find(params[:user_id])
	@project = Project.find(params[:project_id])
    @document_source = @project.document_sources.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @document_source }
    end
  end

  # GET /document_sources/1/edit
  def edit
	@user = User.find(params[:user_id])
	@project = Project.find(params[:project_id])
    @document_source = DocumentSource.find(params[:id])
  end

  # POST /document_sources
  # POST /document_sources.xml
  def create
	@user = User.find(params[:user_id])
	@project = Project.find(params[:project_id])
    @document_source = DocumentSource.new(params[:document_source])

    respond_to do |format|
      if @document_source.save
        flash[:notice] = 'DocumentSource was successfully created.'
        format.html { redirect_to([@user,@project,@document_source]) }
        format.xml  { render :xml => @document_source, :status => :created, :location => @document_source }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @document_source.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /document_sources/1
  # PUT /document_sources/1.xml
  def update
	@user = User.find(params[:user_id])
	@project = Project.find(params[:project_id])
    @document_source = DocumentSource.find(params[:id])

    respond_to do |format|
      if @document_source.update_attributes(params[:document_source])
        flash[:notice] = 'DocumentSource was successfully updated.'
        format.html { redirect_to([@user,@project,@document_source]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @document_source.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /document_sources/1
  # DELETE /document_sources/1.xml
  def destroy
	@user = User.find(params[:user_id])
	@project = Project.find(params[:project_id])
    @document_source = DocumentSource.find(params[:id])
    @document_source.destroy

    respond_to do |format|
      format.html { redirect_to([@user,@project]) }
      format.xml  { head :ok }
    end
  end
  
  def upload
    @user = User.find(params[:user_id])
    @project = Project.find(params[:project_id])
    @document_source = DocumentSource.find(params[:id])
    uploaded_file = params[:import_file]
    @document_source.import_file = uploaded_file
    respond_to do |format|
      flash[:notice] = 'Import file successfully uploaded.'
      format.html { redirect_to([@user,@project,@document_source]) }
      format.xml  { head :ok }
    end
  end
end
