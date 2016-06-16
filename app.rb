require "sinatra"
require_relative "lib/streaker"

helpers do
  def streak_with_days(streak)
    days = streak == 1 ? "day" : "days"
    "#{streak} #{days}"
  end
end

def get_streaks(username)
  return unless username
  begin
    @username = username
    @result = Streaker.get(username)
  rescue Exception => e
    @error = e
  end
end

get "/?:username?" do
  get_streaks(params[:username])
  erb :index, :layout => false
end

post "/" do
  get_streaks(params[:username])
  erb :index, :layout => false
end
