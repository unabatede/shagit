$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "../"))

require 'authorization'
require 'pathname'
require 'config_info'

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
  # get the only instance of the Config class
  config_data = ConfigInfo.instance
  #hostname = `hostname`
  hostname = request.env['SERVER_NAME']
  if (config_data.working_dir == '.')
    full_path = "/#{@current_repo.shagit_foldername}"
  else
    full_path = "#{config_data.working_dir}/#{@current_repo.shagit_foldername}"
  end

  "ssh://#{reformat_string(hostname)}#{reformat_string(full_path)}"
end

def reformat_string(source)
  source.strip
end

def  get_config_file_dir(dir)
  # check whether this is being called from a webrat test and if yes, adjust the calling path for the config_data file
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
    config_data = ConfigInfo.instance

    yaml = YAML.load_file(absolute_filepath)
    config_data.username = yaml['username']
    config_data.password = yaml['password']

    working_dir = yaml['working_dir']

    # check whether working_dir has been specified
    unless (working_dir == nil) || (working_dir.empty?)
      working_dir = working_dir.strip
      # check whether the specified folder exists, if not, set it to the directory Shagit's located at
      if FileTest.directory?(working_dir)
        config_data.working_dir = working_dir
      else
        set_working_dir_to_current_dir
      end
    else
      set_working_dir_to_current_dir
    end
  end
end

def set_working_dir_to_current_dir
  config_data = ConfigInfo.instance
  config_data.working_dir = "."
end

def get_fullpath(path)
  config_data = ConfigInfo.instance

  # add the .git extension if it isn't there already
  if !path.include?('.git')
    path = "#{path}.git"
  end

  fullpath = "#{config_data.working_dir}/#{path}"
end

def check_if_started_from_gem(current_working_directory)
  config_data = ConfigInfo.instance

  # check if the bin folder is included in the directory this file is located in
  if current_working_directory.include?('bin')
    if (config_data.working_dir == '.')
      # extract source installation directory of the gem
      gem_installation_dir = File.dirname(__FILE__).split('bin')[0]
      puts "FATAL ERROR: The directory for saving repositories cannot be used!"
      puts "Please set the path in your #{gem_installation_dir}config.yml accordingly."
      exit
    end

    # if so, we know Shagit has been installed via gem and the application's root folder has to be redirected
    set :root, current_working_directory
  end

  # check if the working directory for saving repositories is writable
  if !FileTest.writable_real?(config_data.working_dir)
    puts "FATAL ERROR: The directory for saving repositories (#{config_data.working_dir}) is not writable!"
    puts "Please adjust your config.yml accordingly."
    exit
  end
end