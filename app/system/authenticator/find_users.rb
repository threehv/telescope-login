require 'ostruct'
require_relative './security_breach'

module Authenticator
  class FindUsers < OpenStruct

    def all login_name = nil
      raise SecurityBreach.new if account.nil? || (account == :false) || !account.admin?
      users = login_name.nil? ? user_storage.all : user_storage.where('login like ?', "%#{login_name}%")
      yield users
    end

    def find name
      raise SecurityBreach.new if account.nil? || (account == :false) || !account.admin?
      yield user_storage.find_by_login name
    end

    # Access users via the ActiveRecord Account class unless we are explicitly overridden
    def user_storage
      super || Masq::Account
    end

  end
end
