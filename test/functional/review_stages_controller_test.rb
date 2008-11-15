require 'test_helper'

class ReviewStagesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:review_stages)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_review_stage
    assert_difference('ReviewStage.count') do
      post :create, :review_stage => { }
    end

    assert_redirected_to review_stage_path(assigns(:review_stage))
  end

  def test_should_show_review_stage
    get :show, :id => review_stages(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => review_stages(:one).id
    assert_response :success
  end

  def test_should_update_review_stage
    put :update, :id => review_stages(:one).id, :review_stage => { }
    assert_redirected_to review_stage_path(assigns(:review_stage))
  end

  def test_should_destroy_review_stage
    assert_difference('ReviewStage.count', -1) do
      delete :destroy, :id => review_stages(:one).id
    end

    assert_redirected_to review_stages_path
  end
end
