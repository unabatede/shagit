module Sinatra
  module Authorization

    def authorize!(username, password)
      # get the only instance of the Config class
      config_data = ConfigInfo.instance

      if (username == config_data.username) && (password == config_data.password)
        session[:authorized] = true
        true
      else
        session[:authorized] = false
        false
      end

    end

    def is_authorized?
      if session[:authorized]
        true
      else
        false
      end
    end

    def requires_login!
      if !is_authorized?
        redirect '/login'
      end
    end

  end
end