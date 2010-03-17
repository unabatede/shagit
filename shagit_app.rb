$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'views'))

require 'rubygems'
require 'sinatra'
require 'haml'

require 'helpers/helpers'
require 'enhancing_grit'
require 'shagit'

use Rack::Session::Cookie, :expire_after => 1200, :secret => 'only Shagit should have access!'

# read in configuration parameters from yaml file and check runtime environment
configure do
  load_config "config.yml"
  check_if_started_from_gem(File.dirname(__FILE__))
end

# set utf-8 as content type for all responses
before do
  headers "Content-Type" => "text/html; charset=uft-8"
end

# display all existing repositories
get '/' do
  requires_login!

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
  
  if authorize!(username, password)
    redirect('/')
  else
    @title = "log in"
    haml :login_failed
  end
end

get '/logout' do
  requires_login!

  @title = "log out"
  session[:authorized] = false
  haml :logout
end

# if no repository has been specified, redirect to index
get '/repo' do
  requires_login!
  redirect('/')
end

# display form to create a new repository
get '/repo/new' do
  requires_login!

  @title = "create new repository"  
  # show form for data entry used to create a new repository
  haml :new
end

# create a new repository
post '/repo/new/?' do
  requires_login!

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
  requires_login!

  @title = "display repository"  
  @current_repo_name = repo
  @current_repo = Repo.new(get_fullpath(repo))
  haml :repo
end

# optimize specified repository
put '/repo/:name/optimize' do |repo|
  requires_login!

  current_repo = Repo.new(get_fullpath(repo))
  current_repo.gc_auto
  redirect "/repo/#{repo}"
end

# display a confirmation form if the repository really shall be deleted
get '/repo/:name/delete' do |repo|
  requires_login!

  @title = "delete repository"
  @current_repo_name = repo
  haml :delete
end

# delete specified repository
delete '/repo/:name' do |repo|
  requires_login!

  @title = "delete repository"
  @confirmation_message = "the repository has been successfully deleted."
  Shagit.delete_repo!(get_fullpath(repo))
  haml :delete_confirmation
end

not_found do
  requires_login!

  status 404
  "Sorry, couldn't find what you were looking for"
end