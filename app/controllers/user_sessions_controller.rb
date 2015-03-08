class UserSessionsController < ApplicationController
  skip_before_filter :require_login, except: [:destroy]

  def new
  	@user = User.new
  end

  def create
  	if @user = login(params[:email], params[:password])
      redirect_to '/events'
    else
      redirect_to(root_path, notice: 'Login failed!')
    end
  end

  def destroy
  	logout
    redirect_to(root_path, notice: 'Logged out!')
  end
end
