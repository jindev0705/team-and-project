class CreateMembersProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :members_projects do |t|
      t.references :member, null: false, index: true, foreign_key: true
      t.references :project, null: false, index: true, foreign_key: true

      t.timestamps
    end
  end
end
