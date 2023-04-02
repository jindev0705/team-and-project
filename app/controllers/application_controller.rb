class ApplicationController < ActionController::Base
  helper :all
  protect_from_forgery with: :null_session
end


