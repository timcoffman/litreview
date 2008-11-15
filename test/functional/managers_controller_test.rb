require 'test_helper'

class ManagersControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:managers)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_managers
    assert_difference('Managers.count') do
      post :create, :managers => { }
    end

    assert_redirected_to managers_path(assigns(:managers))
  end

  def test_should_show_managers
    get :show, :id => managers(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => managers(:one).id
    assert_response :success
  end

  def test_should_update_managers
    put :update, :id => managers(:one).id, :managers => { }
    assert_redirected_to managers_path(assigns(:managers))
  end

  def test_should_destroy_managers
    assert_difference('Managers.count', -1) do
      delete :destroy, :id => managers(:one).id
    end

    assert_redirected_to managers_path
  end
end
