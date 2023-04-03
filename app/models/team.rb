class Team < ApplicationRecord
  validates :name, presence: true

  has_many :member, dependent: :destroy

  def members
    Member.where(team_id: self.id)
  end

end
