$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "../"))

require 'authorization'
require 'pathname'

include Sinatra::Authorization

def stylesheets(*sheets)
  sheets.each { |sheet|
    haml_tag(:link, :href => "/#{sheet}.css", :type => "text/css", :rel => "stylesheet")
  }
end

def cycle(*values)
  @cycles ||= {}
  @cycles[values] ||= -1 # first value returned is 0
  next_value = @cycles[values] = (@cycles[values] + 1) % values.size
  values[next_value]
end

def full_path
  hostname = `hostname`
  full_path = "#{$working_dir}/#{@current_repo.shagit_foldername}"
  "ssh://#{reformat_string(hostname)}#{reformat_string(full_path)}"
end

def reformat_string(source)
  source.strip
end

def  get_config_file_dir(dir)
  # check whether this is being called from a webrat test and if yes, adjust the calling path for the config file
  if dir[/[\w]+$/] == "helpers"
    dir = Pathname.new(File.expand_path(File.dirname(__FILE__)))
    dir.parent.parent
  else
    dir
  end
end

def load_config(file)
  current_dir = File.expand_path(File.dirname(__FILE__))
  absolute_filepath = File.join(get_config_file_dir(current_dir), file)

  if File.exist?(absolute_filepath)
    yaml = YAML.load_file(absolute_filepath)
    $username = yaml['username']
    $password = yaml['password']

    working_dir = yaml['working_dir']

    # check whether working_dir has been specified
    unless (working_dir == nil) || (working_dir.empty?)  
      working_dir = working_dir.strip
      # check whether the specified folder exists, if not, set it to the directory shagit's located at
      if FileTest.directory?(working_dir)
        $working_dir = working_dir
      else
        set_working_dir_to_current_dir
      end
    else
      set_working_dir_to_current_dir
    end
  end
end

def set_working_dir_to_current_dir
  $working_dir = "."
end

def get_fullpath(path)
  # add the .git extension if it isn't there already
  if !path.include?('.git')
    path = "#{path}.git"  
  end

  fullpath = "#{$working_dir}/#{path}"  
end