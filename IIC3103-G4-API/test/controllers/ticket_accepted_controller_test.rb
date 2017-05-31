require 'test_helper'

class TicketAcceptedControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get ticket_accepted_new_url
    assert_response :success
  end

end
