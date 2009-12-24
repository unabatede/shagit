#!/usr/bin/env ruby
require 'rubygems'
require 'grit'
include Grit

# Main class for shagit, initializes and manages all repositories
class Shagit
  attr_reader :repositories

  # checks if a specified directory is a github repository
  def self.is_it_a_gihub_repo?(path)
    if FileTest.directory?(path) && FileTest.directory?("#{path}/hooks") && FileTest.directory?("#{path}/info") && FileTest.directory?("#{path}/objects") && FileTest.directory?("#{path}/refs")
      true
    else
      false
    end
  end

  # initialize shagit by looking for git repositories in specified path
  def initialize
    @repositories = Array.new
    Dir.foreach(".") do |path|
      if self.is_it_a_gihub_repo?(path)
        # create a new Grit repository object if a directory has been found that looks to be a folder containing a git repository
        @repositories << Repo.new(path) unless (path == '.git')
      end
    end
  end

  # creates a new bare repository for the specified path if it doesn't exist already  
  def self.create_repo(name)
    # if the repository already exists, simply return 'false'
    if FileTest.directory?("#{name}.git")
      false
    else
      Grit::Repo.init_bare("#{name}.git")
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