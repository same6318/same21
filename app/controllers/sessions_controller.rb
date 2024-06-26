class SessionsController < ApplicationController
  skip_before_action :login_required, only: [:new, :create]
  before_action :forbid_login_user, only: [:new, :create]

  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      #session[:user_id] = user.id
      log_in(user)
      flash[:notice] = t('.created')
      redirect_to tasks_path
    else
      flash.now[:notice] = "メールアドレスまたはパスワードに誤りがあります"
      render :new
    end
  end

  def destroy
    session.delete(:user_id)
    flash[:notice] = t('.destroyed')
    redirect_to new_session_path
  end

  private

  def forbid_login_user
    if current_user
      flash[:notice] = "ログアウトしてください"
      redirect_to tasks_path
    end
  end

end
