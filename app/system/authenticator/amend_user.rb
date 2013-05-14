require 'ostruct'
require_relative './security_breach'

module Authenticator
  class AmendUser < OpenStruct 
    def delete user_name
      raise SecurityBreach.new if account.nil? || (account == :false) || !account.admin?
      user = user_storage.find_by_login(user_name)
      user.destroy
      yield
    end

    def user_storage
      super || ::Masq::Account
    end
  end
end
