require 'rubygems'
require 'sinatra'
require 'haml'

require 'lib/shagit'
require 'lib/enhancing_grit.rb'

# display all existing repositories
get '/' do
  shagit = Shagit.new
  
  @repo_names = Array.new
  shagit.repositories.each do |repo|
    #repo_name = /([^\/]+\w+$)/.match(repo.path).to_s
    #@repo_names << /\w+[^(.git)]/.match(repo_name).to_s
    @repo_names << repo.repo_name
  end
  
  # show paths of all available repositories
  haml :index
end

# display form to create a new repository
get '/repo/new' do 
  # show form for data entry used to create a new repository
  haml :new
end

# create a new repository
#post '/repo/new/:name' do |repo|
post '/repo/new/?' do
  shagit = Shagit.new
  repo_name = params[:name]

  Shagit.create_repo(repo_name)
  "Repository #{repo_name} created successfully"
end

# display information about one specific repository
get '/repo/:name' do |repo|
   "Displaying repo #{repo}!"
end

not_found do
  "Sorry, couldn't find what you were looking for"
end