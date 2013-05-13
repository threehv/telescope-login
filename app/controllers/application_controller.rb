class ApplicationController < ActionController::Base
  include Masq::AuthenticatedSystem
  protect_from_forgery
  layout 'masq/base'
  rescue_from Authenticator::SecurityBreach, with: :unauthorised

  protected

  def unauthorised
    render template: '/application/unauthorised'
  end
end
