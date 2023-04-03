class MembersProject < ApplicationRecord
  validates :member_id, presence: true
  validates :project_id, presence: true

  belongs_to :member
  belongs_to :project
end
