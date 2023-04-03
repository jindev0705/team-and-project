class TeamsController < ApplicationController

  def new
    @team = Team.new
  end

  def create
    result = helpers.post_request('/api/teams', {
      'authenticity_token' => form_authenticity_token,
      'name' => team_params[:name]
    })

    redirect_to root_path and return unless result.include? 'error'
    redirect_back fallback_location: root_path, notice: result['error'] and return if result.include? 'error'
  end

  def edit
    result = helpers.get_request('/api/teams/' + params[:id])
    @team = Team.find_by(id: result['id'])
    @teams = helpers.get_request('/api/teams')
  end

  def update
    result = helpers.update_request('/api/teams/' + params[:id], {
      'authenticity_token' => form_authenticity_token,
      'name' => team_params[:name]
    })

    redirect_to root_path and return unless result.include? 'error'
    redirect_back fallback_location: root_path, notice: result['error'] and return if result.include? 'error'
  end

  def destroy
    team_members = helpers.get_request('/api/teams/' + params[:id] + '/team_members')
    render json: { result: 'error', message: "You can't delete the team because the team was assigned to any member." } and return if team_members['members'].count > 0

    result = helpers.delete_request('/api/teams/' + params[:id])
    render json: { result: 'success', message: 'The team was deleted successfully.' } and return unless result.include? 'error'
    render json: { result: 'error', message: result['error'] } and return if result.include? 'error'
  end

  def view_members
    @selected_team = helpers.get_request('/api/teams/' + params[:team_id])
    team_members = helpers.get_request('/api/teams/' + params[:team_id] + '/team_members')
    @team_members = team_members['members']
  end



  private

  def team_params
    params.require(:team).permit(:name)
  end

end
