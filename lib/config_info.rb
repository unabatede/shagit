require 'singleton'

class ConfigInfo
  include Singleton

  attr  :username, true
  attr  :password, true
  attr  :working_dir, true
end