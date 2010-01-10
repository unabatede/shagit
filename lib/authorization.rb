module Sinatra
  module Authorization

    def authorize(username, password)
      if (username == $username) && (password == $password)
        session["is_authorized"] ||= true
        true
      else
        session["is_authorized"] ||= false
        false
      end

    end

    def is_authorized?
      if session["is_authorized"]
        true
      else
        false
      end
    end

    def requires_login
      if !is_authorized?
        redirect '/login'
      end
    end

  end
end