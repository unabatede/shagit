# this adds a method called 'repo_name' that returns only the filename without path or file extension
require 'pathname'
require 'find'

module Grit
  # return foldername including extension
  def shagit_foldername
    foldername = Pathname.new(self.path).basename.to_s
  end

  # return foldername from path without extension
  def shagit_name
    #foldername = Pathname.new(self.path).basename.to_s
    foldername = Pathname.new(self.shagit_foldername).basename.to_s
    repo_name = foldername.match(/^[\w\s]+/).to_s
  end

  #Êreturn size of folder containing the repository in Kilobytes
  def shagit_size
    #size = `du -ks #{self.path} | cut -f 1`
    dirsize = 0
    #Êrecursively search the repositories path and sum up all file sizes
    Find.find(self.path) do |f|
      dirsize += File.stat(f).size
    end

    dirsize
  end
end