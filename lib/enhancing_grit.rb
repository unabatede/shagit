# this adds a method called 'repo_name' that returns only the filename without path or file extension
require 'pathname'

module Grit
  def repo_name
    filename = Pathname.new(self.path).basename.to_s
    repo_name = filename.match(/^[\w\s]+/).to_s
  end
end