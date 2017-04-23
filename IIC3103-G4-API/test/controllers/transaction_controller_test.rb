require 'test_helper'

class TransactionControllerTest < ActionDispatch::IntegrationTest
  test "should get originAccount:string" do
    get transaction_originAccount:string_url
    assert_response :success
  end

  test "should get destinationAccount:string" do
    get transaction_destinationAccount:string_url
    assert_response :success
  end

  test "should get amount:double" do
    get transaction_amount:double_url
    assert_response :success
  end

end
