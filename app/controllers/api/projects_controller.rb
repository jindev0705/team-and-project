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
      render json: { project: @project, status: :ok }
    else
      render json: { error: @project.errors, status: :unprocessable_entity }
    end
  end

  def update
    update_result = @project.update(project_params)
    if update_result
      render json: { project: @project, status: :ok }
    else
      render json: { error: @project.errors, status: :unprocessable_entity }
    end
  end

  def destroy
    if @project.destroy
      render json: { project: @project, status: :ok }
    else
      render json: { error: @project.errors, status: :unprocessable_entity }
    end
  end

  def project_members
    members = @project.members
    render json: { members: members, status: :ok }
  end

  def add_member
    member_id = params[:member_id]
    render json: {result: 'No exist member', status: :no_content} and return if Member.find_by_id(member_id).nil?

    if @project.add_member(member_id)
      render json: { status: :ok }
    else
      render json: { status: :unprocessable_entity }
    end

  end

  private
  def set_project
    @project = Project.find_by_id(params[:id])
    if @project.nil?
      render json: {result: 'No exist the project', status: :no_content}
    end
  end

  def set_project_by_project_id
    @project = Project.find_by_id(params[:project_id])
    render json: {result: 'No exist the team', status: :no_content} if @project.nil?
  end

  def project_params
    params.permit(:name)
  end
  
end
