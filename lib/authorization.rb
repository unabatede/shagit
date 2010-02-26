module Sinatra
  module Authorization

    def authorize!(username, password)
      if (username == $username) && (password == $password)
        session[:authorized] = true
        true
      else
        session[:authorized] = false
        puts "received: |#{username}| |#{password}|"
        puts "should be: |#{$username}| |#{$password}|"
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