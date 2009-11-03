#!/usr/bin/env ruby
require 'rubygems'
require 'grit'
include Grit

# Main class for shagit, initializes and manages all repositories
class Shagit
  attr_reader :repositories
  
  # initialize shagit by looking for git repositories in specified path
  def initialize
    @repositories = Array.new
    Dir.foreach(".") do |path| 
      if FileTest.directory?(path) && FileTest.directory?("#{path}/hooks") && FileTest.directory?("#{path}/info") && FileTest.directory?("#{path}/objects") && FileTest.directory?("#{path}/refs")
        # create a new Grit repository object if a directory has been found that looks to be a folder containing a git repository
        # @repositories << Repo.new(path) unless (path == "." || path == "..")
        @repositories << Repo.new(path)
      end
    end
  end
  
  # creates a new bare repository for the specified path
  def self.create_repo(name)
    Grit::Repo.init_bare("#{name}.git")
  end
end