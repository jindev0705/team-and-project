class Member < ApplicationRecord
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :team_id, presence: true

  belongs_to :team
  has_and_belongs_to_many :projects

  def alter_team team_id
    self.update(team_id: team_id)
  end
end
