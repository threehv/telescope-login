class Admin::UsersController < ApplicationController
  def index
    find_user.all(query) do | users | 
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
      flash[:notice] = "#{user.login} has been added"
      redirect_to admin_users_path
    end
  rescue ActiveRecord::RecordInvalid => invalid
    flash[:error] = 'Unable to add user'
    render action: 'new', locals: { user: invalid.record }
  end

  def edit
    find_user.find user_name do | user |
      render action: 'edit', locals: { user: user }
    end
  end

  def update
    user_editor.update user_name, with: user_params do | user |
      flash[:notice] = "#{user.login} has been updated"
      redirect_to admin_users_path
    end
  rescue ActiveRecord::RecordInvalid => invalid
    flash[:error] = 'Unable to update user'
    render action: 'edit', locals: { user: invalid.record }
  end

  def remove
    find_user.find user_name do | user | 
      render action: 'remove', locals: { user: user }
    end
  end

  def destroy
    user_editor.delete user_name do
      redirect_to admin_users_path
    end
  end

  protected

  def find_user
    Authenticator::FindUsers.new account: current_account
  end

  def user_builder
    Authenticator::UserBuilder.new account: current_account
  end

  def user_editor
    Authenticator::AmendUser.new account: current_account
  end

  def user_params
    params[:account].slice(:login, :email, :password, :password_confirmation)
  end

  def user_name
    params[:id]
  end

  def query
    params[:q]
  end
end
