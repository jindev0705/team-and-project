class Project < ApplicationRecord
  validates :name, presence: true

  has_and_belongs_to_many :members

  def add_member member_id
    member_project = MembersProject.new(member_id: member_id, project_id: self.id)
    member_project.save
  end

  def members
    MembersProject.joins(:member).select("members.*").where(project_id: self.id)
  end
end
