class ProjectsController < ApplicationController

  def new
    @project = Project.new
  end

  def create
    result = helpers.post_request('/api/projects', {
      'authenticity_token' => form_authenticity_token,
      'name' => project_params[:name]
    })

    if result['status'] == 'ok'
      redirect_to root_path
    else
      redirect_back fallback_location: root_path, notice: result['error']
    end
  end

  def edit
    result = helpers.get_request('/api/projects/' + params[:id])
    @project = Project.find_by(id: result['id'])
    @projects = helpers.get_request('/api/projects')
  end

  def update
    result = helpers.update_request('/api/projects/' + params[:id], {
      'authenticity_token' => form_authenticity_token,
      'name' => project_params[:name]
    })

    if result['status'] == 'ok'
      redirect_to root_path
    else
      redirect_back fallback_location: root_path, notice: result['error']
    end
  end

  def destroy
    result = helpers.delete_request('/api/projects/' + params[:id])
    render json: { result: 'success', message: 'The project was deleted successfully.' } and return if result['status'] == 'ok'
    render json: { result: 'error', message: result['error'] } and return unless result['status'] == 'ok'
  end

  def view_members
    @selected_project = helpers.get_request('/api/projects/' + params[:project_id])
    project_members = helpers.get_request('/api/projects/' + params[:project_id] + '/project_members')
    @project_members = project_members['members']
  end

  def new_members
    @project = helpers.get_request('/api/projects/' + params[:project_id])
    project_members = helpers.get_request('/api/projects/' + params[:project_id] + '/project_members')
    @project_members = project_members['members']
    @members = helpers.get_request('/api/members')
  end

  def add_member
    result = helpers.post_request('/api/projects/' + params[:project_id] + '/add_member', {
      'authenticity_token' => form_authenticity_token,
      'member_id' => params[:member_id]
    })

    if result['status'] == 'ok'
      redirect_to root_path
    else
      redirect_back fallback_location: root_path, notice: result['error']
    end
  end



  private

  def project_params
    params.require(:project).permit(:name)
  end
  
end
