require 'rubygems'
require 'sinatra'
require 'haml'

require 'lib/shagit'

# display all existing repositories
get '/' do
  shagit = Shagit.new
  
  @repo_paths = Array.new
  shagit.repositories.each do |repo|
    @repo_paths << repo.path
  end
  
  # show the paths of all available repositories
  @repo_paths
  #haml :index
end

# create a new repository
get '/repo/new/:name' do |repo|
  shagit = Shagit.new
  
  Shagit.create_repo(repo)
  "Repository #{repo} created successfully"
end

# display information about one specific repository
get '/repo/:name' do |repo|
   "Displaying repo #{repo}!"
end

not_found do
  "Sorry, couldn't find what you were looking for"
end