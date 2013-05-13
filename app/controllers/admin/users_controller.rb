class Admin::UsersController < ApplicationController
  def index
    find_users.all do | users | 
      render action: 'index', locals: { users: users }
    end
  end

  protected

  def find_users
    Authenticator::FindUsers.new account: current_account
  end
end
