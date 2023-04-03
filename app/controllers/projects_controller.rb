class ProjectsController < ApplicationController

  def new
    @project = Project.new
  end

  def create
    result = helpers.post_request('/api/projects', {
      'authenticity_token' => form_authenticity_token,
      'name' => project_params[:name]
    })

    redirect_to root_path and return unless result.include? 'error'
    redirect_back fallback_location: root_path, notice: result['error'] and return if result.include? 'error'
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

    redirect_to root_path and return unless result.include? 'error'
    redirect_back fallback_location: root_path, notice: result['error'] and return if result.include? 'error'
  end

  def destroy
    result = helpers.delete_request('/api/projects/' + params[:id])
    render json: { result: 'success', message: 'The project was deleted successfully.' } and return unless result.include? 'error'
    render json: { result: 'error', message: result['error'] } and return if result.include? 'error'
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

    redirect_to root_path and return if result
    redirect_back fallback_location: root_path, notice: result['error']
  end



  private

  def project_params
    params.require(:project).permit(:name)
  end
  
end
