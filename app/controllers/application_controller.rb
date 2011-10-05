class ApplicationController < ActionController::Base
  authentication = Settings.authentication!
  if authentication.basic_auth
    http_basic_authenticate_with :name => authentication[:username], :password => authentication[:password]
  end
  protect_from_forgery
end
