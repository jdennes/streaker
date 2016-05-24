require "uri"
require "faraday"

module Streaker
  # Get the streak details for a GitHub user, where a streak is defined as the
  # total number of consecutive days that the user has no GitHub contributions.
  #
  # username - A String representing the username of the GitHub user. e.g. "torvalds"
  #
  # Returns a Hash containing the following:
  #   :longest_streak - The user's longest streak of inactivity.
  #   :current_streak - The user's current streak of inactivity.
  def self.get(username)
    conn = Faraday.new(:url => "https://github.com") do |faraday|
      faraday.adapter Faraday.default_adapter
    end
    response = conn.get "/users/#{username}/contributions"
    svg = response.body
    contributions = svg.scan(/^\s*<rect.*data-count="(\d+)".*\/>\s*$/i)
      .flatten
      .map(&:to_i)
    if contributions.empty?
      raise "No contributions data found for '#{username}'"
    end

    calculate_streaks(contributions)
  end

  # Calculate the longest and current streaks, given an ordered array of
  # Integers, where each entry represents the number of contributions for a day.
  #
  # contributions - An an ordered array of Integers, where each entry represents
  #                 the number of contributions for a day.
  #
  # Returns a Hash containing the following:
  #   :longest_streak - The user's longest streak of inactivity.
  #   :current_streak - The user's current streak of inactivity.
  def self.calculate_streaks(contributions)
    streaks = []
    days = 0
    contributions.each_with_index do |contrib, index|
      if contrib == 0
        # If the contribution count is 0, increment days of streak
        days += 1
        if index == contributions.size - 1
          # Check whether we need to add a streak if this is
          # the last contribution
          streaks << days
        end
      else
        # Otherwise, the streak is over (if it started)
        streaks << days if days > 0
        days = 0
      end
    end

    longest_streak = streaks.max
    current_streak = contributions.last == 0 ? streaks.last : 0
    {
      :longest_streak => longest_streak,
      :current_streak => current_streak
    }
  end
end
