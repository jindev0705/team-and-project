class Api::ProjectsController < ApplicationController

  before_action :set_project, only: %i[ show update destroy ]
  before_action :set_project_by_project_id, only: %i[ project_members add_member]

  def index
    @projects = Project.all

    render json: @projects
  end

  def show
    render json: @project
  end

  def create
    @project = Project.new(project_params)

    if @project.save
      render json: { project: @project }, status: :ok
    else
      render json: { error: @project.errors }, status: :unprocessable_entity
    end
  end

  def update
    update_result = @project.update(project_params)
    if update_result
      render json: { project: @project }, status: :ok
    else
      render json: { error: @project.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    if @project.destroy
      render json: { project: @project }, status: :ok
    else
      render json: { error: @project.errors }, status: :unprocessable_entity
    end
  end

  def project_members
    members = @project.members
    render json: { members: members }, status: :ok
  end

  def add_member
    member_id = params[:member_id]
    render json: { error: 'No exist the member' }, status: :unprocessable_entity and return if Member.find_by(id: member_id).nil?

    if @project.add_member(member_id)
      head :ok
    else
      head :unprocessable_entity
    end

  end

  private
  def set_project
    @project = Project.find_by(id: params[:id])
    if @project.nil?
      render json: { error: 'No exist the project' }, status: :unprocessable_entity
    end
  end

  def set_project_by_project_id
    @project = Project.find_by(id: params[:project_id])
    render json: { error: 'No exist the project' }, status: :unprocessable_entity if @project.nil?
  end

  def project_params
    params.permit(:name)
  end
  
end
