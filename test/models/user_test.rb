require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'points should be the sum of all user\'s bets' do
    john = users(:john)
    susan = users(:susan)
    lily = users(:lily)
    mark = users(:mark)
    carol = users(:carol)

    assert_equal 20, john.points
    assert_equal 35, susan.points
    assert_equal 15, lily.points
    assert_equal 5, mark.points
    assert_equal 0, carol.points
  end
end
