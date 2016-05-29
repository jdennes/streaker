require "minitest/autorun"
require_relative "../lib/streaker"

class TestStreaker < Minitest::Test

  def test_that_calculate_streaks_works
    contributions = [ 2, 3, 0, 0, 5, 6, 1, 0 ]
    expected_streaks = { :longest_streak => 2, :current_streak => 1 }
    streaks = Streaker.calculate_streaks(contributions)
    assert_equal expected_streaks, streaks
  end

  def test_that_get_works
    result = Streaker.get("torvalds")
    assert result.is_a? Hash
    assert result[:longest_streak].is_a? Integer
    assert result[:current_streak].is_a? Integer
  end

  def test_that_get_raises_an_error_when_no_data_is_found
    username = "not----a--github--user"
    expected_error_message = "No contributions data found for '#{username}'."
    error = assert_raises RuntimeError do
      Streaker.get(username)
    end
    assert_equal expected_error_message, error.message
  end

end
