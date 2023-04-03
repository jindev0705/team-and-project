class MembersController < ApplicationController

  def index
    @members = helpers.get_request('/api/members')
    @teams = helpers.get_request('/api/teams')
    @projects = helpers.get_request('/api/projects')
  end

  def new
    @member = Member.new
    @teams = helpers.get_request('/api/teams')
  end

  def create
    result = helpers.post_request('/api/members', {
      'authenticity_token' => form_authenticity_token,
      'first_name' => member_params[:first_name],
      'last_name' => member_params[:last_name],
      'city' => member_params[:city],
      'state' => member_params[:state],
      'country' => member_params[:country],
      'team_id' => member_params[:team_id]
    })

    if result['status'] == 'ok'
      redirect_to root_path
    else
      redirect_back fallback_location: root_path, notice: result['error']
    end
  end

  def edit
    result = helpers.get_request('/api/members/' + params[:id])
    @member = result.size.zero? ? nil : Member.find(result[0]['id'])
    @teams = helpers.get_request('/api/teams')
  end

  def update
    result = helpers.update_request('/api/members/' + params[:id], {
      'authenticity_token' => form_authenticity_token,
      'first_name' => member_params[:first_name],
      'last_name' => member_params[:last_name],
      'city' => member_params[:city],
      'state' => member_params[:state],
      'country' => member_params[:country],
      'team_id' => member_params[:team_id]
    })

    if result['status'] == 'ok'
      redirect_to root_path
    else
      redirect_back fallback_location: root_path, notice: result['error']
    end
  end

  def destroy
    result = helpers.delete_request('/api/members/' + params[:id])

    if result['status'] == 'ok'
      render json: { result: 'success', message: 'The member was deleted successfully.' }
    else
      render json: { result: 'error', message: result['error'] }
    end

  end

  private

  def member_params
    params.require(:member).permit(:first_name, :last_name, :city, :state, :country, :team_id)
  end
end
