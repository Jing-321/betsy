class UsersController < ApplicationController

  before_action :find_user, only: [:show]

  # TBD - What are we doing for  login => Authentication or Authorization?

  # def login_form
  #   @user = User.new
  # end
  # ==> Do we need a login_form html.erb file?
  def create
    @user = User.find_by(username: params[:username])

    if guest?
      @user = guest_user
      session[:user_id] = @user.id
      session[:guest_user_id] = nil
      redirect_to user_path(@user)
    elsif @user == nil
      flash[:error] = 'Username does not exist'
      redirect_to login_path
    else
      if @user.authenticate(params[:password])
        session[:user_id] = @user.id
        redirect_to user_path(@user)
      else
        flash[:error] = 'Username and Password do not match'
        redirect_to login_path
      end
    end
  end

  def login
    user = User.find_by(username: params[:user][:username])
    # New User
    if user.nil?
      user = User.new(username: params[:user][:username])
      unless user.save
        flash[:error] = 'Unexpected error occured. Login unsuccessful.'
        redirect_to root_path
        return
      end
      flash[:welcome] = "Welcome #{user.username}"
    else
      # Existing User
      flash[:welcome] = "Welcome back #{user.username}"
    end

    session[:user_id] = user.id
    redirect_to root_path
  end

  def index
    @users = User.all
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

  def logout
    if session[:user_id]
      user = User.find_by(id: session[:user_id])
      if user.nil?
        session[:user_id] = nil
        flash[:notice] = 'Error! Unknown User'
      else
        session[:user_id] = nil
        flash[:notice] = "Goodbye #{user.username}"
      end
    else
      flash[:error] = 'You must be logged in to logout'
      redirect_to root_path
    end
    redirect_to root_path
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
