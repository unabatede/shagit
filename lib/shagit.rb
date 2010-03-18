#!/usr/bin/env ruby
require 'rubygems'
require 'grit'
require 'config_info'
include Grit

# Main class for shagit, initializes and manages all repositories
class Shagit
  attr_reader :repositories

  # checks if a specified directory is a github repository
  def self.is_it_a_git_repo?(path)
    if FileTest.directory?(path) && FileTest.directory?("#{path}/hooks") && FileTest.directory?("#{path}/info") && FileTest.directory?("#{path}/objects") && FileTest.directory?("#{path}/refs")
      true
    else
      false
    end
  end

  # initialize shagit by looking for git repositories in specified path
  def initialize
    # get the only instance of the Config class
    config_data = ConfigInfo.instance

    @repositories = Array.new
    Dir.foreach(config_data.working_dir) do |path|
      fullpath = "#{config_data.working_dir}/#{path}"

      if Shagit.is_it_a_git_repo?(fullpath)
        # create a new Grit repository object if a directory has been found that looks to be a folder containing a git repository
        @repositories << Repo.new(fullpath) unless (path == '.git')
      end
    end
  end

  # creates a new bare repository for the specified path if it doesn't already exist  
  def self.create_repo(full_repo_name)
    # if the repository already exists, simply return 'false'
    if FileTest.directory?(full_repo_name)
      false
    else
      Grit::Repo.init_bare(full_repo_name)
    end
  end

  # deletes an existing repository
  def self.delete_repo!(full_repo_name)
    if FileTest.directory?(full_repo_name)
      FileUtils.rm_rf(full_repo_name)
      true
    else
      false
    end
  end

end