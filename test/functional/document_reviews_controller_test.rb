require 'test_helper'

class DocumentReviewsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:document_reviews)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_document_review
    assert_difference('DocumentReview.count') do
      post :create, :document_review => { }
    end

    assert_redirected_to document_review_path(assigns(:document_review))
  end

  def test_should_show_document_review
    get :show, :id => document_reviews(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => document_reviews(:one).id
    assert_response :success
  end

  def test_should_update_document_review
    put :update, :id => document_reviews(:one).id, :document_review => { }
    assert_redirected_to document_review_path(assigns(:document_review))
  end

  def test_should_destroy_document_review
    assert_difference('DocumentReview.count', -1) do
      delete :destroy, :id => document_reviews(:one).id
    end

    assert_redirected_to document_reviews_path
  end
end
