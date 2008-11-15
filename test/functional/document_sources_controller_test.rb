require 'test_helper'

class DocumentSourcesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:document_sources)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_document_source
    assert_difference('DocumentSource.count') do
      post :create, :document_source => { }
    end

    assert_redirected_to document_source_path(assigns(:document_source))
  end

  def test_should_show_document_source
    get :show, :id => document_sources(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => document_sources(:one).id
    assert_response :success
  end

  def test_should_update_document_source
    put :update, :id => document_sources(:one).id, :document_source => { }
    assert_redirected_to document_source_path(assigns(:document_source))
  end

  def test_should_destroy_document_source
    assert_difference('DocumentSource.count', -1) do
      delete :destroy, :id => document_sources(:one).id
    end

    assert_redirected_to document_sources_path
  end
end
