class DocumentsController < ApplicationController
  # GET /documents
  # GET /documents.xml
  
  before_filter :load_context
  
  def load_context
    @user = User.find(params[:user_id])
    @project = Project.find(params[:project_id])
  end
  private :load_context
  
  def index
  conditions = {}
  conditions[:document_source_id] = params[:source] if params[:source]
	@limit = params[:limit] || current_user.preferred_documents_page_limit || 10
	@limit = @limit.to_i
	@offset = params[:offset] || 0
	@offset = @offset.to_i
    @documents = @project.documents.find(:all,:limit => @limit, :offset => @offset, :include => [ :document_source, :duplicate_of_document, :duplicate_documents ], :conditions => conditions )
    @document_count = @project.documents.count(:all, :conditions => conditions)
	@page = ( @offset / @limit ).floor
	@pages = ( @document_count / @limit ).ceil
	current_user.preferred_documents_page_limit = @limit 

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @documents }
    end
  end

  # GET /documents/1
  # GET /documents/1.xml
  def show
    @document = @project.documents.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @document }
    end
  end

  # GET /documents/new
  # GET /documents/new.xml
  def new
    @document = @project.documents.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @document }
    end
  end

  # GET /documents/1/edit
  def edit
    @document = @project.documents.find(params[:id])
  end

  # POST /documents
  # POST /documents.xml
  def create
    @document = @project.documents.new(params[:document])

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
    @document = @project.documents.find(params[:id])

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

  def new_tags
    @document = @project.documents.find(params[:id])
    result = { :status => :ok, :document_tags => [ ], :tags => [ ] }
    for words in (params[:tag_words] || "").split( /\s/ )
      tag = Tag.find_best( words, @user, @project )
      unless tag
        tag = Tag.create( :words => words, :created_by_user_id => @user.id, :created_for_project_id => @project.id )
        result[:tags] << tag
      end
      document_tag = @document.document_tags.find( :first, :conditions => { :tag_id => tag.id, :applied_by_user_id => @user } )
      unless document_tag
      	document_tag = @document.document_tags.create( :tag_id => tag.id, :applied_by_user_id => @user )
        result[:document_tags] << document_tag
      end
    end
    respond_to do |format|
      format.html { redirect_to([@user,@project,@document]) }
      format.js { render :xml => result }
    end
  end
  
  # DELETE /documents/1
  # DELETE /documents/1.xml
  def destroy
    @document = @project.documents.find(params[:id])
    @document.destroy

    respond_to do |format|
      format.html { redirect_to([@user,@project]) }
      format.xml  { head :ok }
    end
  end
  
  def match_duplicates
    @document = @project.documents.find(params[:id])

    respond_to do |format|
      format.html # match_duplicates.html.erb
      format.xml  { render :xml => @document }
    end
  end
end
