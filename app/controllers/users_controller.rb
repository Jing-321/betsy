class UsersController < ApplicationController

  before_action :find_user, only: [:show]
  before_action :current, only: [:show]


  def create
    auth_hash = request.env["omniauth.auth"]
    user = User.find_by(uid: auth_hash["uid"], provider: auth_hash["provider"])
    if user
      flash[:success] = "Welcome back #{user.username}!"
    else
      user = User.build_from_github(auth_hash)
      if user.save
        flash[:success] = "Logged in as new user #{user.username}."
      else
        flash[:error] = "Sorry, could not create new account #{user.errors.message}"
        return redirect_to root_path
      end
    end

    session[:user_id] = user.id
    return redirect_to root_path
  end


  def destroy
    session[:user_id] = nil
    flash[:success] = "Logged out. See you next time!"
    return redirect_to root_path
  end

  def index
    @users = User.where.not("uid = nil")
  end

  def show
    if @user.nil?
      head :not_found
      return
    end
  end

  def current
    @current_user = User.find_by(id: session[:user_id])
    unless @current_user
      flash[:error] = 'You must be logged in to see this page'
      redirect_to root_path
      return
    end
  end

  def create_guest
    session[:guest_user_id] = save_guest.id
  end

  def save_guest
    user = User.create(username: 'guest', password: 'guest')
    user.save(validate: false)
    user
  end

  def guest_user
    User.find(session[:guest_user_id]) if session[:guest_user_id]
  end

  def guest?
    !!guest_user
  end

  private

  def find_user
    @user = User.find_by(id: params[:id])
  end

end
