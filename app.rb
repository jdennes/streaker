require "sinatra"
require_relative "lib/streaker"

helpers do
  def streak_with_days(streak)
    days = streak == 1 ? "day" : "days"
    "#{streak} #{days}"
  end
end

get "/" do
  erb :index, :layout => false
end

post "/" do
  begin
    @username = params[:username]
    @result = Streaker.get(params[:username])
  rescue Exception => e
    @error = e
  end

  erb :index, :layout => false
end
