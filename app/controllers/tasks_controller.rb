class TasksController < ApplicationController
  # before_action :signed_in_user, only: [:create, :destroy, :change_status]
  before_action :correct_project,   only: [:create, :destroy, :change_status, :edit, :update]

  def create
    @task = @project.tasks.build(task_params)
    if @task.save
      flash[:success] = "task created!"
      redirect_to project_path(@project)
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    @task = @project.tasks.find_by(id: params[:id])
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
    @task = @project.tasks.find_by(id: params[:id])
  end

  def update
    @task = @project.tasks.find_by(id: params[:id])
    if @task.update_attributes(task_params)
      flash[:success] = "Task updated"
      redirect_to @project
    else
      render "edit"
    end
  end

  private

    def task_params
      params.require(:task).permit(:content, :planed_time, :actual_time)
    end

    def correct_project
      @project = Project.find(params[:project_id])
      redirect_to root_url if @project.nil?
    end
end
