class AddTeamRefToMembers < ActiveRecord::Migration[7.0]
  def change
    add_reference :members, :team, null: false, foreign_key: true
  end
end
