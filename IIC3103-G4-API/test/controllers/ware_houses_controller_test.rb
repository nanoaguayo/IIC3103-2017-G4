require 'test_helper'

class WareHousesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ware_house = ware_houses(:one)
  end

  test "should get index" do
    get ware_houses_url, as: :json
    assert_response :success
  end

  test "should create ware_house" do
    assert_difference('WareHouse.count') do
      post ware_houses_url, params: { ware_house: { dispatch: @ware_house.dispatch, pulmon: @ware_house.pulmon, reception: @ware_house.reception, totalspace: @ware_house.totalspace, usedspace: @ware_house.usedspace } }, as: :json
    end

    assert_response 201
  end

  test "should show ware_house" do
    get ware_house_url(@ware_house), as: :json
    assert_response :success
  end

  test "should update ware_house" do
    patch ware_house_url(@ware_house), params: { ware_house: { dispatch: @ware_house.dispatch, pulmon: @ware_house.pulmon, reception: @ware_house.reception, totalspace: @ware_house.totalspace, usedspace: @ware_house.usedspace } }, as: :json
    assert_response 200
  end

  test "should destroy ware_house" do
    assert_difference('WareHouse.count', -1) do
      delete ware_house_url(@ware_house), as: :json
    end

    assert_response 204
  end
end
