class TasksController < ApplicationController
  # before_action :signed_in_user, only: [:create, :destroy, :change_status]
  before_action :correct_project, only: [:create, :destroy, :change_status, :edit, :update, :sort, :calculate]
  before_action :correct_task, only: [:destroy, :edit, :update]
  before_action :project_tasks, only: [:sort, :calculate]
  DAY_MAX_TIMES = 300

  def create
    @task = @project.tasks.build(task_params)
    if @task.save
      flash[:success] = "task created!"
      redirect_to project_path(@project)
    else
      @feed_items = []
      render "static_pages/home"
    end
  end

  def destroy
    @task.destroy
    redirect_to project_path(@project)
  end

  def change_status
    @task = @project.tasks.find_by(id: params[:task_id])
    @task.send(params[:action_name])
    @task.save
    redirect_to project_path(@project)
  end

  def edit
  end

  def update
    respond_to do |format|
      if @task.update_attributes(task_params)
        format.html { redirect_to @project, flash: { success: "Task updated"} }
        format.js { render :success }
      else
        format.html { render :edit }
        format.js { render :error }
      end
    end
  end

  def sort
    i = 0
    @tasks.each do |task|
      # 移動したタスクにはparams[:order]を当てる
      if task.id == params[:id].to_i
        task.order = params[:order].to_i
        task.save
        next
      end

      # params[:order]より大きい場合はparams[:order]と被らないように+1する
      task.order = (i < params[:order].to_i ? i : i + 1)
      task.save
      i += 1
    end

    respond_to do |format|
      format.js { render :success }
    end
  end

  def calculate
    create_dailies(task_times)
    redirect_to project_path(@project)
  end

  def task_times
    task_times = @tasks.order(:order).each_with_object([]) do |task, task_times|
      surplus_time = task_times.last.present? ? (DAY_MAX_TIMES - task_times.last.sum { |t| t[:time] }) : DAY_MAX_TIMES
      task_last = task_times.last.present? ? task_times.last : task_times

      if surplus_time <= task.planed_time
        next_time = task.planed_time - surplus_time
        task_last << time_hash(task_last, { id: task.id, time: surplus_time }) unless surplus_time.zero?

        div, mod = next_time.divmod(DAY_MAX_TIMES)
        div.times { |i| task_times << [{ id: task.id, time: DAY_MAX_TIMES }] }
        task_times << [{ id: task.id, time: mod }] unless mod.zero?
      else
        task_last << time_hash(task_last, { id: task.id, time: task.planed_time })
      end
    end
  end

  private

  def create_dailies(task_times)
    Daily.destroy_all(task_id: @tasks.map(&:id))
    @project.start_date.bussiness_dates(task_times.size).zip(task_times).each do |date, tasks|
      tasks.each do |t|
        daily = Daily.find_or_create_by(the_date: date, task_id: t[:id])
        daily.planed_time = t[:time]
        daily.save
      end
    end
  end

  def time_hash(task_last, time_hash)
    task_last.present? ? time_hash : [time_hash]
  end

  def task_params
    params.require(:task).permit(:content, :planed_time, :actual_time, :user_id)
  end

  def correct_project
    @project = Project.find(params[:project_id])
    redirect_to root_url if @project.nil?
  end

  def correct_task
    @task = @project.tasks.find_by(id: params[:id])
    redirect_to root_url if @task.nil?
  end

  def project_tasks
    @tasks = @project.tasks.order(:order)
  end
end
