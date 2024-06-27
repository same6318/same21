class Admin::UsersController < ApplicationController
  before_action :require_admin

  def index
    @users = User.eager_load(:tasks)
  end
    #eager_loadでタスクテーブルを結合した状態でローディング

  def new
    @user = User.new
  end

  def show
    #binding.irb
    @user = User.find(params[:id])
    @tasks = @user.tasks.all
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "ユーザを登録しました"
      redirect_to admin_users_path
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "ユーザを更新しました"
      redirect_to admin_users_path
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      flash[:notice] = "ユーザを削除しました"
    else
      flash[:notice] = "管理者が0人になるため削除できません"
    end
    redirect_to admin_users_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :admin, :password, :password_confirmation)
  end

  def require_admin
    unless current_user.admin?
      flash[:notice] = "管理者以外アクセスできません"
      redirect_to tasks_path
    end
  end

end
