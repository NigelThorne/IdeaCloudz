require 'sinatra'
require 'haml'

# Goal
## suggest ideas
## vote ideas
## toggle vote per idea per person
## remove ideas with no votes


@@votes ||= {}

enable :sessions

get '/' do
	@user = session[:user]
	@votes = @@votes
	haml :index
end

post '/add_idea' do
  voters = @@votes[params["idea"]] ||= []
  voters << session[:user]
  voters.uniq!
  redirect '/'
end

post '/vote' do
  voters = @@votes[params["idea"]]
  name = session[:user]
  if voters.include? name
	voters.delete name
	@@votes.delete(params["idea"]) if voters.empty?
  else
	voters << name
  end
  redirect '/'
end

post '/login' do
  session[:user] = params["name"]
  redirect '/'
end

post '/logout' do
  session[:user] = nil
  redirect '/'
end

