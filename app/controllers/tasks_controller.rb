class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :current_user

  def index
    # @tasks = Task.all.created_at_sort.page(params[:page]).per(10) #ページネーションさせるデータに.page(params[:page])を追加
    if @search_params = task_search_params.presence
      # binding.irb
        @tasks = current_user.tasks.search(@search_params).created_at_sort.page(params[:page]).per(10)
    elsif params[:deadline_asc_sort]
      # binding.irb
      @tasks = current_user.tasks.deadline_asc_sort.created_at_sort.page(params[:page]).per(10)
    elsif params[:priority_high_sort]
      @tasks = current_user.tasks.priority_high_sort.created_at_sort.page(params[:page]).per(10)
    else
      @tasks = current_user.tasks.created_at_sort.page(params[:page]).per(10)
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
    @task[:user_id] = current_user.id
    # binding.irb
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
    params.require(:task).permit(:title, :content, :deadline_on, :priority, :status, { label_ids: [] })
  end

  def set_task
    @task = Task.find_by(id: params[:id], user_id: @current_user.id)
    #この場合、直接URLを入力しても、params[:id]は取得できるが、user_id:が合致しないため、nilが返る。
    unless @task
      flash[:notice] = "アクセス権限がありません"
      redirect_to tasks_path
    end
  end

  def task_search_params
    params.fetch(:search, {}).permit(:title, :status, :label)
  end

end
