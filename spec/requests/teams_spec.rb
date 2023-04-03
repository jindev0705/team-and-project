require 'rails_helper'

RSpec.describe Api::TeamsController, type: :request do
  include TeamsHelper

  describe 'GET /api/teams' do
    let!(:teams) { create_teams(3)}
    before { get api_teams_url }

    it 'returns a 200 status code' do
      expect(response).to have_http_status(200)
    end

    it 'returns all teams' do
      expect(JSON.parse(response.body).size).to eq(Team.count)
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end

  describe 'GET /api/teams/:id' do
    let(:team) { create_teams(1) }

    context 'when the record exists' do
      before { get api_team_url(team.id) }

      it 'returns a 200 status code' do
        expect(response).to have_http_status(200)
      end

      it 'returns the team' do
        expect(response.body).not_to be_empty
        expect(JSON.parse(response.body)['id']).to eq(team.id)
      end
    end

    context 'when the record does not exist' do
      before { get api_team_url(0) }

      it 'returns "No exist the team"' do
        expect(JSON.parse(response.body)['error']).to eq('No exist the team')
      end
    end

  end

  describe "POST /api/teams" do
    context 'with valid parameters' do
      let(:valid_params) { { name: 'my team' }}
      it 'creates a new team' do
        expect {
          post api_teams_url, params: valid_params
        }.to change(Team, :count).by(1)
      end

      it 'returns a status code of 200' do
        post api_teams_url, params: valid_params
        expect(response).to have_http_status(200)
      end

      it 'returns the newly created team as JSON' do
        post api_teams_url, params: valid_params
        expect(JSON.parse(response.body)['team'].to_json).to eq(Team.last.to_json)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) { { name: '' } }

      it 'does not create a new team' do
        expect {
          post api_teams_url, params: invalid_params
        }.not_to change(Team, :count)
      end

      it 'returns a status code of 422' do
        post api_teams_url, params: invalid_params
        expect(response).to have_http_status(422)
      end

      it 'returns an error message as JSON' do
        post api_teams_url, params: invalid_params
        expect(response.body).to eq({ error: { name: ["can't be blank"] } }.to_json)
      end
    end

  end

  describe 'PUT /api/teams/:id' do
    let(:team) { create_teams(1) }

    context 'when the team exists' do
      before { put api_team_url(team.id), params: { name: 'developer team' } }

      it 'returns a 200 status code' do
        expect(response).to have_http_status(200)
      end

      it 'updates the team' do
        expect(team.reload.name).to eq('developer team')
      end

      it 'returns the team' do
        expect(response.body).not_to be_empty
        expect(JSON.parse(response.body).size).to eq(1)
      end
    end

    context 'when the team does not exist' do
      before { put api_team_url(0), params: { name: 'developer team' } }

      it 'returns "No exist the team"' do
        expect(JSON.parse(response.body)['error']).to eq('No exist the team')
      end
    end
  end


  describe 'DELETE /api/teams/:id' do
    let(:team) { create_teams(1) }

    context "when the team exist" do
      before { delete api_team_url(team.id) }

      it 'returns a 200 status code' do
        expect(response.status).to eq(200)
      end

      it 'deletes the team' do
        expect(Team.exists?(team.id)).to be false
      end
    end

    context "when the user does not exist" do
      before { delete api_team_url(0) }

      it 'returns a 422 status code' do
        expect(response.status).to eq(422)
      end

      it 'returns "No exist the team"' do
        expect(JSON.parse(response.body)['error']).to eq('No exist the team')
      end
    end
  end
end
