class UsersController < ApplicationController
  skip_before_action :login_required, only: [:new, :create]
  before_action :correct_user, only: [:show, :edit, :update, :destroy]
  before_action :forbid_login_user, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    # binding.irb
    if @user.save
      log_in(@user)
      flash[:notice] = t('.created')
      redirect_to user_path(@user.id)
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      log_in(@user)
      flash[:notice] = t('.updated')
      redirect_to user_path
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to new_session_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def correct_user
    # binding.irb
    @user = User.find(params[:id])
    unless current_user?(@user)
      flash[:notice] = "ログインしてください"
      redirect_to current_user
    end
  end

  def forbid_login_user
    if current_user
      flash[:notice] = "ログアウトしてください"
      redirect_to tasks_path
    end
  end

end
