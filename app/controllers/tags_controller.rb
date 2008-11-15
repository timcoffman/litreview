class TagsController < ApplicationController

  before_filter :require_login

  # GET /stage_reviewers
  # GET /stage_reviewers.xml
  def index
    @tags = Tag.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @stage_reviewers }
    end
  end

  # GET /stage_reviewers/1
  # GET /stage_reviewers/1.xml
  def show
    @tag = Tag.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @stage_reviewer }
    end
  end

end
