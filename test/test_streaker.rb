require "minitest/autorun"
require_relative "../lib/streaker"

class TestStreaker < Minitest::Test

  def test_that_streaks_can_be_calculated
    contributions = [ 2, 3, 0, 0, 5, 6, 1, 0 ]
    expected_streaks = { :longest_streak => 2, :current_streak => 1 }
    streaks = Streaker.calculate_streaks(contributions)
    assert_equal expected_streaks, streaks
  end

end
