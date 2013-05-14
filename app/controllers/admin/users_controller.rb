class Admin::UsersController < ApplicationController
  def index
    find_users.all do | users | 
      render action: 'index', locals: { users: users }
    end
  end

  def new
    user_builder.start do | user |
      render action: 'new', locals: { user: user }
    end
  end

  def create
    user_builder.create_using user_params do | user |
      flash[:notice] = "#{user} has been added"
      redirect_to admin_users_path
    end
  rescue ActiveRecord::RecordInvalid => invalid
    flash[:error] = 'Unable to add user'
    render action: 'new', locals: { user: invalid.record }
  end

  protected

  def find_users
    Authenticator::FindUsers.new account: current_account
  end

  def user_builder
    Authenticator::UserBuilder.new account: current_account
  end

  def user_params
    params[:account].slice(:login, :email, :password, :password_confirmation)
  end
end
