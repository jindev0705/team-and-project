class Api::MembersController < ApplicationController

  before_action :set_member, only: %i[ update destroy ]

  def index
    @members = Member.joins(:team).select("members.*, teams.name team_name")

    render json: @members
  end

  def show
    @member = Member.joins(:team).select("members.*, teams.name team_name").where("members.id=?", params[:id])
    render json: @member
  end

  def create
    team = Team.find_by_id(member_params[:team_id])
    if team.nil?
      render json: {result: 'No exist the team', status: :no_content }
    else
      @member = Member.new(member_params)
      if @member.save
        render json: { member: @member, status: :ok }
      else
        render json: { error: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    team = Team.find_by_id(member_params[:team_id])
    if team.nil?
      render json: {result: 'No exist the team', status: :no_content }
    else
      update_result = @member.update(member_params)
      if update_result
        render json: { member: @member, status: :ok }
      else
        render json: { error: @member.errors, status: :unprocessable_entity }
      end
    end

  end

  def alter_team
    member = Member.find_by_id(params[:member_id])
    team_id = params[:team_id]
    render json: {result: 'No exist the member', status: :no_content } and return if member.nil?
    render json: {result: 'No exist the team', status: :no_content} and return if Team.find_by_id(team_id).nil?
    if member.alter_team(team_id)
      render json: { status: :ok }
    else
      render json: { status: :unprocessable_entity}
    end
  end

  def destroy
    if @member.destroy
      render json: { member: @member, status: :ok }
    else
      render json: { error: @member.errors, status: :unprocessable_entity }
    end
  end


  private
  def set_member
    @member = Member.find(params[:id])
    if @member.nil?
      render json: {result: 'No exist member', status: :ok}
    end
  end

  def member_params
    params.permit(:first_name, :last_name, :city, :state, :country, :team_id)
  end
end
