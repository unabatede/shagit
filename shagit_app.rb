$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "lib/"))

require 'rubygems'
require 'sinatra'
require 'haml'

require 'helpers/helpers'
require 'enhancing_grit'
require 'shagit'

# enable cookie-based sessions
#enable :sessions
# changed according to Webrat Documentation
use Rack::Session::Cookie

# read in credentials for admin user
configure do
  load_config "config.yml"
end

# display all existing repositories
get '/' do
  requires_login

  @shagit = Shagit.new
  @title = "all repositories"
  
  # show paths of all available repositories
  haml :index
end

# display the login form
get '/login' do
  @title = "log in"
  haml :login
end

# check whether the provided username and password are correct
post '/login' do
  username = params[:username]
  password = params[:password]
  
  if authorize(username, password)
    redirect('/')
  else
    @title = "log in"
    haml :login_failed
  end
end

get '/logout' do
  requires_login

  @title = "log out"
  session["is_authorized"] = false
  haml :logout
end

# if no repository has been specified, redirect to index
get '/repo' do
  requires_login
  redirect('/')
end

# display form to create a new repository
get '/repo/new' do
  requires_login

  @title = "create new repository"  
  # show form for data entry used to create a new repository
  haml :new
end

# create a new repository
post '/repo/new/?' do
  requires_login

  @title = "create new repository"
  repo = params[:name]

  if Shagit.create_repo(get_fullpath(repo))
    @confirmation_message = "Repository <a href='#{repo}.git'>#{repo}</a> created successfully"
  else
    @confirmation_message = "Could not create repository"
  end
  haml :new_confirmation
end

# display information about one specific repository
get '/repo/:name' do |repo|
  requires_login

  @title = "display repository"  
  @current_repo_name = repo
  @current_repo = Repo.new(get_fullpath(repo))
  haml :repo
end

# optimize specified repository
put '/repo/:name/optimize' do |repo|
  requires_login

  current_repo = Repo.new(get_fullpath(repo))
  current_repo.gc_auto
  redirect "/repo/#{repo}"
end

# display a confirmation form if the repository really shall be deleted
get '/repo/:name/delete' do |repo|
  requires_login

  @title = "delete repository"
  @current_repo_name = repo
  haml :delete
end

# delete specified repository
delete '/repo/:name' do |repo|
  requires_login

  @title = "delete repository"
  @confirmation_message = "the repository has been successfully deleted."
  Shagit.delete_repo!(get_fullpath(repo))
  haml :delete_confirmation
end

not_found do
  requires_login

  status 404
  "Sorry, couldn't find what you were looking for"
end