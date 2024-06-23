class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    @tasks = Task.all.page(params[:page]).per(10) #ページネーションさせるデータに.page(params[:page])を追加
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      flash[:notice] = t('.created')
      redirect_to tasks_path
    else
      flash.now[:notice] = "タスクの作成に失敗しました"
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @task.update(task_params)
      flash[:notice] = t('.updated')
      redirect_to task_path(@task)
    else
      flash.now[:notice] = "タスクの更新に失敗しました"
      render :edit
    end
  end

  def destroy
    @task.destroy
    flash[:notice] = t('.destroyed')
    redirect_to tasks_path
  end



  private

  def task_params
    params.require(:task).permit(:title, :content)
  end

  def set_task
    @task = Task.find(params[:id])
  end

end
