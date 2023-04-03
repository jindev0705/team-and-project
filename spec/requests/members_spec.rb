require 'rails_helper'

RSpec.describe Api::MembersController, type: :request do
  include MembersHelper

  describe 'GET /api/members' do
    let!(:members) { create_list(3)}
    before { get api_members_url }

    it 'returns a 200 status code' do
      expect(response).to have_http_status(200)
    end

    it 'returns all members' do
      expect(JSON.parse(response.body).size).to eq(Member.count)
      expect(JSON.parse(response.body).size).to eq(3)
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

      it 'returns a status code of 201' do
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


end
