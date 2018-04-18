require 'test_helper'

class AdminTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  #
  test "create empty admin" do
    admin = Admin.new
    assert_not admin.save, "Did save empty admin"
  end

end
