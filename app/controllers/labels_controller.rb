class LabelsController < ApplicationController
  before_action :set_label, only: [:edit, :update, :destroy]

  def index
    @labels = current_user.labels.all
  end

  def new
    @label = Label.new
  end

  def create
    @label = Label.new(label_params)
    @label[:user_id] = current_user.id
    if @label.save
      flash[:notice] = t('.created')
      redirect_to labels_path
    else
      flash.now[:notice] = "ラベルの作成に失敗しました"
      render :new
    end
  end

  def edit
  end

  def update
    if @label.update(label_params)
      flash[:notice] = t(".updated")
      redirect_to labels_path
    else
      flash.now[:notice] = "ラベルの更新に失敗しました"
      render :edit
    end
  end

  def destroy
    if @label.destroy
      flash[:notice] = t(".destroyed")
      redirect_to labels_path
    else
      flash[:notice] = "ラベルの削除に失敗しました"
      redirect_to labels_path
    end
  end

  private

  def set_label
    @label = Label.find_by(id: params[:id], user_id: current_user.id)
    unless @label
      flash[:notice] = "アクセス権限がありません"
      redirect_to labels_path
    end
  end

  def label_params
    params.require(:label).permit(:name)
  end

end
