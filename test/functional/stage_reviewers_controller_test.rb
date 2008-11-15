require 'test_helper'

class StageReviewersControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:stage_reviewers)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_stage_reviewer
    assert_difference('StageReviewer.count') do
      post :create, :stage_reviewer => { }
    end

    assert_redirected_to stage_reviewer_path(assigns(:stage_reviewer))
  end

  def test_should_show_stage_reviewer
    get :show, :id => stage_reviewers(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => stage_reviewers(:one).id
    assert_response :success
  end

  def test_should_update_stage_reviewer
    put :update, :id => stage_reviewers(:one).id, :stage_reviewer => { }
    assert_redirected_to stage_reviewer_path(assigns(:stage_reviewer))
  end

  def test_should_destroy_stage_reviewer
    assert_difference('StageReviewer.count', -1) do
      delete :destroy, :id => stage_reviewers(:one).id
    end

    assert_redirected_to stage_reviewers_path
  end
end
