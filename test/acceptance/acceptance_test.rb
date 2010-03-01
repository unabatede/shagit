$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "../../lib"))

require 'shagit_app'

require "rack/test"
require "webrat"
require "test/unit"

Webrat.configure do |config|
  config.mode = :rack
  config.application_port = 4567
  config.application_framework = :sinatra
end

class AcceptanceTest < Test::Unit::TestCase
  include Rack::Test::Methods
  include Webrat::Methods
  include Webrat::Matchers

  def app
    Sinatra::Application.new
  end

  def test_00_log_in_screen_displayed
    visit "/"
    assert_contain("log in")
    assert_contain("username")
    assert_contain("password")
    assert_contain("login")
  end

  def test_01_logging_in
    visit "/login"
    fill_in "username", :with => "admin"
    fill_in "password", :with => "admin"
    click_button "login"
    assert_contain("all repositories")
  end

  def test_02_no_repositories_available
    test_01_logging_in
    visit "/"
    assert_contain("None found?!")
  end

  def test_03_adding_new_repository
    test_01_logging_in
    visit "/"
    click_link "create your first repository"
    assert_contain("create new repository")
    fill_in "name", :with => "webrat"
    click_button "create"
    assert_contain("Repository webrat created successfully")
  end

  def test_04_displaying_info_on_existing_repository
    test_01_logging_in
    visit "/"
    click_link "webrat"
    assert_contain("display repository")
    assert_contain("actions for this repository")
  end

  def test_05_optimizing_repository
    test_01_logging_in
    visit "/repo/webrat.git"
    assert_contain("display repository")
    assert_contain("actions for this repository")
    click_button "optimize"
  end

  def test_06_deleting_repository
    test_01_logging_in
    visit "/repo/webrat.git/delete"
    assert_contain(" Are you sure you want to delete the following repository?")
    click_button "yes"
    assert_contain("the repository has been successfully deleted.")
  end

  def test_07_logging_out
    test_01_logging_in
    visit "/"
    click_link "log out"
    assert_contain("you have successfully been logged out. see you next time!")
    assert_contain("or do you want to log in again?")
  end
end
