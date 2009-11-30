require 'test_helper'

class AllocationsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:allocations)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_allocations
    assert_difference('Allocations.count') do
      post :create, :allocations => { }
    end

    assert_redirected_to allocations_path(assigns(:allocations))
  end

  def test_should_show_allocations
    get :show, :id => allocations(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => allocations(:one).id
    assert_response :success
  end

  def test_should_update_allocations
    put :update, :id => allocations(:one).id, :allocations => { }
    assert_redirected_to allocations_path(assigns(:allocations))
  end

  def test_should_destroy_allocations
    assert_difference('Allocations.count', -1) do
      delete :destroy, :id => allocations(:one).id
    end

    assert_redirected_to allocations_path
  end
end
