class Api::TeamsController < ApplicationController

  before_action :set_team, only: %i[ show update destroy ]

  def index
    @teams = Team.all

    render json: @teams
  end

  def show
    render json: @team
  end

  def create
    @team = Team.new(team_params)

    if @team.save
      render json: { team: @team }, status: :ok
    else
      render json: { error: @team.errors }, status: :unprocessable_entity
    end
  end

  def update
    update_result = @team.update(team_params)
    if update_result
      render json: { team: @team }, status: :ok
    else
      render json: { error: @team.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    if @team.destroy
      render json: { team: @team }, status: :ok
    else
      render json: { error: @team.errors }, status: :unprocessable_entity
    end
  end

  def team_members
    team = Team.find_by(id: params[:team_id])
    render json: { error: 'No exist the team' }, status: :unprocessable_entity and return if team.nil?

    members = team.members
    render json: { members: members }, status: :ok
  end

  private
  def set_team
    @team = Team.find_by(id: params[:id])
    if @team.nil?
      render json: { error: 'No exist the team' }, status: :unprocessable_entity
    end
  end

  def team_params
    params.permit(:name)
  end
  
end
