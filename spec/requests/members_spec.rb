require 'rails_helper'

RSpec.describe Api::MembersController, type: :request do
  include MembersHelper

  describe 'GET /api/members' do
    let!(:members) { create_members(3)}
    before { get api_members_url }

    it 'returns a 200 status code' do
      expect(response).to have_http_status(200)
    end

    it 'returns all members' do
      expect(JSON.parse(response.body).size).to eq(Member.count)
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end

  describe 'GET /api/members/:id' do
    let(:member) { create_members(1) }

    context 'when the record exists' do
      # before { get '/api/members/' + member[0].id.to_s }
      before { get api_member_url(member.id) }

      it 'returns a 200 status code' do
        expect(response).to have_http_status(200)
      end

      it 'returns the member' do
        expect(response.body).not_to be_empty
        expect(JSON.parse(response.body)[0]['id']).to eq(member.id)
      end
    end

    context 'when the record does not exist' do
      before { get api_member_url(0) }

      it 'returns empty list' do
        expect(JSON.parse(response.body).size).to eq(0)
      end
    end

  end

  describe "POST /api/members" do
    let(:team) { Team.create(name: 'my team') }
    context 'with valid parameters' do
      let(:valid_params) { { first_name: 'rails', last_name: 'developer', city: 'rails developer city', state: 'rails developer state', country: 'rails developer country', team_id: team.id }}
      it 'creates a new post' do
        expect {
          post api_members_url, params: valid_params
        }.to change(Member, :count).by(1)
      end

      it 'returns a status code of 200' do
        post api_members_url, params: valid_params
        expect(response).to have_http_status(200)
      end

      it 'returns the newly created member as JSON' do
        post api_members_url, params: valid_params
        expect(JSON.parse(response.body)['member'].to_json).to eq(Member.last.to_json)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) { { first_name: '', last_name: '', team_id: '' } }

      it 'does not create a new member' do
        expect {
          post api_members_url, params: invalid_params
        }.not_to change(Member, :count)
      end

      it 'returns a status code of 422' do
        post api_members_url, params: invalid_params
        expect(response).to have_http_status(422)
      end

      it 'returns an error message as JSON' do
        post api_members_url, params: invalid_params
        expect(response.body).to eq({ error: { first_name: ["can't be blank"], last_name: ["can't be blank"], team_id: ["can't be blank"], team: ["must exist"] } }.to_json)
      end
    end

  end

  describe 'PUT /api/members/:id' do
    let(:member) { create_members(1) }

    context 'when the member exists' do
      let(:team) { Team.create(id: 5, name: 'my team') }
      before { put api_member_url(member.id), params: { first_name: 'my', last_name: 'tester', team_id: team.id } }

      it 'returns a 200 status code' do
        expect(response).to have_http_status(200)
      end

      it 'updates the member' do
        expect(member.reload.first_name).to eq('my')
        expect(member.reload.last_name).to eq('tester')
        expect(member.reload.team_id).to eq(5)
      end

      it 'returns the member' do
        expect(response.body).not_to be_empty
        expect(JSON.parse(response.body).size).to eq(1)
      end
    end

    context 'when the member does not exist' do
      let(:team) { Team.create(id: 5, name: 'my team') }
      before { put api_member_url(0), params: { first_name: 'my', last_name: 'tester', team_id: team.id } }

      it 'returns "No exist the member"' do
        expect(JSON.parse(response.body)['error']).to eq('No exist the member')
      end
    end
  end


  describe 'POST /api/members/:member_id/alter_team' do
    let(:member) { create_members(1) }

    context 'when the member and the team exists' do
      let(:team) { Team.create(id: 5, name: 'my team') }
      before { post api_member_alter_team_url(member.id), params: { team_id: team.id } }

      it 'returns a 200 status code' do
        expect(response).to have_http_status(200)
      end

      it 'updates the team of the member' do
        expect(member.reload.team_id).to eq(5)
      end
    end

    context 'when the member does not exist' do
      let(:team) { Team.create(id: 5, name: 'my team') }
      before { post api_member_alter_team_url(0), params: { team_id: team.id } }

      it 'returns "No exist the member"' do
        expect(JSON.parse(response.body)['error']).to eq('No exist the member')
      end
    end

    context 'when the team does not exist' do
      before { post api_member_alter_team_url(member.id), params: { team_id: 0 } }

      it 'returns "No exist the team"' do
        expect(JSON.parse(response.body)['error']).to eq('No exist the team')
      end
    end

  end

  describe 'DELETE /api/members/:id' do
    let(:member) { create_members(1) }

    context "when the member exist" do
      before { delete api_member_url(member.id) }

      it 'returns a 200 status code' do
        expect(response.status).to eq(200)
      end

      it 'deletes the member' do
        expect(Member.exists?(member.id)).to be false
      end
    end

    context "when the user does not exist" do
      before { delete api_member_url(0) }

      it 'returns a 422 status code' do
        expect(response.status).to eq(422)
      end

      it 'returns "No exist the member"' do
        expect(JSON.parse(response.body)['error']).to eq('No exist the member')
      end
    end
  end
end
