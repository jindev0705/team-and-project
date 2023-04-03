module MembersHelper
  def create_members(record_numbers)
    # Set default attributes for the list
    team = Team.create(name: 'my test team')
    attrs = {
      first_name: 'sprintfwd',
      last_name: 'developer',
      team_id: team.id
    }

    # Create the list with the given attributes
    if record_numbers == 1
      Member.create!(attrs)
    else
      lists = []
      record_numbers.times do
        lists << Member.create!(attrs)
      end
      lists
    end

  end

end