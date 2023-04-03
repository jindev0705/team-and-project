module MembersHelper
  def create_list(record_numbers)
    # Set default attributes for the list
    team = Team.create(name: 'my test team')
    attrs = {
      first_name: 'My List',
      last_name: 'A list of items',
      team_id: team.id
    }

    # Create the list with the given attributes
    lists = []
    record_numbers.times do
      lists << Member.create!(attrs)
    end
    lists
  end
end