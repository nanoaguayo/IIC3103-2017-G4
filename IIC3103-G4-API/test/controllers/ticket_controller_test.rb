require 'test_helper'

class TicketControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get ticket_new_url
    assert_response :success
  end

end
