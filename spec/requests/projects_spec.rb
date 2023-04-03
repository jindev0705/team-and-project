require 'rails_helper'

RSpec.describe Api::ProjectsController, type: :request do
  include MembersHelper
  include ProjectsHelper

  # get all projects
  describe 'GET /api/projects' do
    let!(:projects) { create_projects(3)}
    before { get api_projects_url }

    it 'returns a 200 status code' do
      expect(response).to have_http_status(200)
    end

    it 'returns all projects' do
      expect(JSON.parse(response.body).size).to eq(Project.count)
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end

  # get a project
  describe 'GET /api/projects/:id' do
    let(:project) { create_projects(1) }

    context 'when the record exists' do
      before { get api_project_url(project.id) }

      it 'returns a 200 status code' do
        expect(response).to have_http_status(200)
      end

      it 'returns the project' do
        expect(response.body).not_to be_empty
        expect(JSON.parse(response.body)['id']).to eq(project.id)
      end
    end

    context 'when the record does not exist' do
      before { get api_project_url(0) }

      it 'returns "No exist the project"' do
        expect(JSON.parse(response.body)['error']).to eq('No exist the project')
      end
    end

  end

  # create a new project
  describe "POST /api/projects" do
    context 'with valid parameters' do
      let(:valid_params) { { name: 'my project' }}
      it 'creates a new project' do
        expect {
          post api_projects_url, params: valid_params
        }.to change(Project, :count).by(1)
      end

      it 'returns a status code of 200' do
        post api_projects_url, params: valid_params
        expect(response).to have_http_status(200)
      end

      it 'returns the newly created project as JSON' do
        post api_projects_url, params: valid_params
        expect(JSON.parse(response.body)['project'].to_json).to eq(Project.last.to_json)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) { { name: '' } }

      it 'does not create a new project' do
        expect {
          post api_projects_url, params: invalid_params
        }.not_to change(Project, :count)
      end

      it 'returns a status code of 422' do
        post api_projects_url, params: invalid_params
        expect(response).to have_http_status(422)
      end

      it 'returns an error message as JSON' do
        post api_projects_url, params: invalid_params
        expect(response.body).to eq({ error: { name: ["can't be blank"] } }.to_json)
      end
    end

  end

  # update a project
  describe 'PUT /api/projects/:id' do
    let(:project) { create_projects(1) }

    context 'when the project exists' do
      before { put api_project_url(project.id), params: { name: 'developer project' } }

      it 'returns a 200 status code' do
        expect(response).to have_http_status(200)
      end

      it 'updates the project' do
        expect(project.reload.name).to eq('developer project')
      end

      it 'returns the project' do
        expect(response.body).not_to be_empty
        expect(JSON.parse(response.body).size).to eq(1)
      end
    end

    context 'when the project does not exist' do
      before { put api_project_url(0), params: { name: 'developer project' } }

      it 'returns "No exist the project"' do
        expect(JSON.parse(response.body)['error']).to eq('No exist the project')
      end
    end
  end

  # delete a project
  describe 'DELETE /api/projects/:id' do
    let(:project) { create_projects(1) }

    context "when the project exist" do
      before { delete api_project_url(project.id) }

      it 'returns a 200 status code' do
        expect(response.status).to eq(200)
      end

      it 'deletes the project' do
        expect(Project.exists?(project.id)).to be false
      end
    end

    context "when the user does not exist" do
      before { delete api_project_url(0) }

      it 'returns a 422 status code' do
        expect(response.status).to eq(422)
      end

      it 'returns "No exist the project"' do
        expect(JSON.parse(response.body)['error']).to eq('No exist the project')
      end
    end
  end

  # add a member to a project
  describe "POST /api/projects/:project_id/add_member" do
    let(:member) { create_members(1) }
    let(:project) { create_projects(1) }

    context 'with valid parameters' do
      let(:valid_params) { { member_id: member.id }}
      it 'add a member' do
        expect {
          post api_project_add_member_url(project.id), params: valid_params
        }.to change(MembersProject, :count).by(1)
      end

      it 'returns a status code of 200' do
        post api_project_add_member_url(project.id), params: valid_params
        expect(response).to have_http_status(200)
      end
    end

    context 'with invalid member parameters' do
      let(:invalid_params) { { member_id: 0 } }

      it 'does not add a member' do
        expect {
          post api_project_add_member_url(project.id), params: invalid_params
        }.not_to change(MembersProject, :count)
      end

      it 'returns "No exist the member"' do
        post api_project_add_member_url(project.id), params: invalid_params
        expect(JSON.parse(response.body)['error']).to eq('No exist the member')
      end
    end

    context 'with invalid project parameters' do
      let(:invalid_params) { { member_id: member.id } }

      it 'does not add a member' do
        expect {
          post api_project_add_member_url(0), params: invalid_params
        }.not_to change(MembersProject, :count)
      end

      it 'returns "No exist the project"' do
        post api_project_add_member_url(0), params: invalid_params
        expect(JSON.parse(response.body)['error']).to eq('No exist the project')
      end
    end

  end

  # get all members of the project
  describe 'GET /api/projects/:project_id/project_members' do
    let(:members) { create_members(3) }
    let(:project) { create_projects(1) }

    context 'with valid parameters' do
      before { post api_project_add_member_url(project.id), params: { member_id: members[0].id } }
      before { post api_project_add_member_url(project.id), params: { member_id: members[1].id } }
      before { post api_project_add_member_url(project.id), params: { member_id: members[2].id } }
      before { get api_project_project_members_url(project.id) }
      it 'returns a 200 status code' do
        expect(response).to have_http_status(200)
      end

      it 'returns all members of the project' do
        get api_project_project_members_url(project.id)
        expect(JSON.parse(response.body)['members'].size).to eq(MembersProject.count)
        expect(JSON.parse(response.body)['members'].size).to eq(3)
      end
    end

    context 'when invalid parameters' do
      before { get api_project_url(0) }

      it 'returns "No exist the project"' do
        expect(JSON.parse(response.body)['error']).to eq('No exist the project')
      end
    end

  end

end
