require 'rubygems'
require 'sinatra'
require 'haml'
require 'sass'

require 'helpers/helpers'
require 'lib/enhancing_grit'
require 'lib/shagit'

# display all existing repositories
get '/' do
  @shagit = Shagit.new
                                 
  #@repo_names = Array.new
  #shagit.repositories.each do |repo|
  #  @repo_names << repo.shagit_name
  #end
  
  # show paths of all available repositories
  haml :index
end

# if no repository has been specified, redirect to index
get '/repo' do
  redirect('/')
end

# display form to create a new repository
get '/repo/new' do 
  # show form for data entry used to create a new repository
  haml :new
end

# create a new repository
#post '/repo/new/:name' do |repo|
post '/repo/new/?' do
  #shagit = Shagit.new
  repo_name = params[:name]

  if Shagit.create_repo(repo_name)
    "Repository #{repo_name} created successfully"
  else
    "Could not create repository"
  end
end

# display information about one specific repository
get '/repo/:name' do |repo|
  @current_repo_name = repo
  @current_repo = Repo.new(repo)
  haml :repo
end

# optimize specified repository
post '/repo/:name/optimize' do |repo| 
  current_repo = Repo.new(repo)
  current_repo.gc_auto
  #"Done optimizing."
  redirect "/repo/#{repo}"
end

not_found do
  "Sorry, couldn't find what you were looking for"
end