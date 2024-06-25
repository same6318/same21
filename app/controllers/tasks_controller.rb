class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    # @tasks = Task.all.created_at_sort.page(params[:page]).per(10) #ページネーションさせるデータに.page(params[:page])を追加
    if @search_params = task_search_params.presence
      # binding.irb
      @tasks = Task.search(@search_params).created_at_sort.page(params[:page]).per(10)
    elsif params[:deadline_asc_sort]
      # binding.irb
      @tasks = Task.deadline_asc_sort.created_at_sort.page(params[:page]).per(10)
    elsif params[:priority_high_sort]
      @tasks = Task.priority_high_sort.created_at_sort.page(params[:page]).per(10)
    else
      @tasks = Task.created_at_sort.page(params[:page]).per(10)
    end
    # binding.irb
    # if params[:deadline_asc_sort]
    #   @tasks = Task.deadline_asc_sort
    # elsif params[:priority_high_sort]
    #   @tasks = Task.priority_high_sort
    # else
    # end
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
    params.require(:task).permit(:title, :content, :deadline_on, :priority, :status)
  end

  def set_task
    @task = Task.find(params[:id])
  end

  def task_search_params
    params.fetch(:search, {}).permit(:title, :status)
  end

end
