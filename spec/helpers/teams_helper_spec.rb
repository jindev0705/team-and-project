module TeamsHelper
  def create_teams(record_numbers)
    # Set default attributes for the list
    attrs = { name: 'Sprint FWD' }

    # Create the list with the given attributes
    if record_numbers == 1
      Team.create!(attrs)
    else
      lists = []
      record_numbers.times do
        lists << Team.create!(attrs)
      end
      lists
    end

  end

end