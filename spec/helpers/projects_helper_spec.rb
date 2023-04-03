module ProjectsHelper
  def create_projects(record_numbers)
    # Set default attributes for the list
    attrs = { name: 'Test Project' }

    # Create the list with the given attributes
    if record_numbers == 1
      Project.create!(attrs)
    else
      lists = []
      record_numbers.times do
        lists << Project.create!(attrs)
      end
      lists
    end

  end

end