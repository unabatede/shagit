require 'rubygems'
require 'sinatra'
require 'haml'

require 'helpers/helpers'
require 'lib/enhancing_grit'
require 'lib/shagit'

# read in credentials for admin user
configure do
  load_config "./config.yml"
end

# make sure every request is authorized
before do
  require_administrative_privileges
end

# display all existing repositories
get '/' do
  @shagit = Shagit.new
  @title = "all repositories"
  
  # show paths of all available repositories
  haml :index
end

# if no repository has been specified, redirect to index
get '/repo' do
  redirect('/')
end

# display form to create a new repository
get '/repo/new' do
  @title = "create new repository"  
  # show form for data entry used to create a new repository
  haml :new
end

# create a new repository
#post '/repo/new/:name' do |repo|
post '/repo/new/?' do
  @title = "create new repository"
  #shagit = Shagit.new
  repo_name = params[:name]

  if Shagit.create_repo(repo_name)
    @confirmation_message = "Repository <a href='#{repo_name}.git'>#{repo_name}</a> created successfully"
  else
    @confirmation_message = "Could not create repository"
  end
  haml :new_confirmation
end

# display information about one specific repository
get '/repo/:name' do |repo|
  @title = "display repository"  
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

# display a confirmation form if the repository really shall be deleted
get '/repo/:name/delete' do |repo|
  @title = "delete repository"
  @current_repo_name = repo
  haml :delete
end

# delete specified repository
post '/repo/:name/delete' do |repo|
  @title = "delete repository"
  @confirmation_message = "the repository has been successfully deleted."
  Shagit.delete_repo!(repo)  
  haml :delete_confirmation
end

not_found do
  "Sorry, couldn't find what you were looking for"
end
