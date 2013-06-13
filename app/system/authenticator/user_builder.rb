require 'ostruct'
require_relative './security_breach'

module Authenticator
  class UserBuilder < OpenStruct
    def start
      raise SecurityBreach.new if account.nil? || (account == :false) 
      yield user_storage.new
    end

    def create_using params
      raise SecurityBreach.new if account.nil? || (account == :false)
      yield user_storage.create!(params)
    end

    def user_storage
      super || ::Masq::Account
    end
  end
end
