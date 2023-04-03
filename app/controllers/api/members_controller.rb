class Api::MembersController < ApplicationController

  before_action :set_member, only: %i[ update destroy ]

  def index
    @members = Member.joins(:team).select("members.*, teams.name team_name")

    render json: @members, status: :ok
  end

  def show
    @member = Member.joins(:team).select("members.*, teams.name team_name").where("members.id=?", params[:id])
    render json: @member, status: :ok
  end

  def create
    @member = Member.new(member_params)
    result = @member.save
    render json: { member: @member }, status: :ok and return if result
    render json: { error: @member.errors }, status: :unprocessable_entity and return unless result
  end

  def update
    result = @member.update(member_params)
    render json: { member: @member }, status: :ok and return if result
    render json: { error: @member.errors }, status: :unprocessable_entity and return unless result
  end

  def alter_team
    member = Member.find_by(id: params[:member_id])
    team_id = params[:team_id]

    render json: { error: 'No exist the member' } , status: :unprocessable_entity and return if member.nil?
    render json: { error: 'No exist the team' }, status: :unprocessable_entity and return if Team.find_by_id(team_id).nil?

    result = member.alter_team(team_id)
    head :ok and return if result
    head :unprocessable_entity and return unless result
  end

  def destroy
    result = @member.destroy
    render json: { member: @member }, status: :ok and return if result
    render json: { error: @member.errors }, status: :unprocessable_entity and return unless result
  end


  private
  def set_member
    @member = Member.find_by(id: params[:id])
    if @member.nil?
      render json: { error: 'No exist the member' }, status: :unprocessable_entity
    end
  end

  def member_params
    params.permit(:first_name, :last_name, :city, :state, :country, :team_id)
  end
end
