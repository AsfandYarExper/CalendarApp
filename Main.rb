require 'date'
require_relative 'events.rb'
require_relative 'helper_functions'

FILE_NAME = 'events.txt'.freeze
File.open(FILE_NAME, 'w') { |events_file| }

puts 'Please select an option from the menu'

loop do
  puts '1 : Print current month with events'
  puts '2 : Print specific month with events'
  puts '3 : Add new event'
  puts '4 : Remove event'
  puts '5 : Edit event'
  puts '6 : Remove all events'
  puts '7 : Print specific event'

  option = gets.chomp.to_i

  if Integer(option)

    case option

    when 1
      current_month = Date.today.strftime('%m')
      current_year = Date.today.strftime('%Y')
      date = Date.new(current_year.to_i, current_month.to_i, 1)

      events_directory = Helper_functions.read_file

      Helper_functions.print_month(events_directory, date)

    when 2
      puts 'Enter the month and year of the event in the following format: MM-yyyy'
      entered_date = gets.chomp
      date = '1-' + entered_date

      events_directory = Helper_functions.read_file

      Helper_functions.validate_date(date)
      Helper_functions.print_month(events_directory, date)

    when 3

      puts 'Adding a new Event:'
      puts 'Enter the name of event'
      name = gets.chomp
      puts 'Enter the date of event in the following format: dd-MM-yyyy'
      date = gets.chomp

      Helper_functions.validate_date(date)

      puts 'What is the status of the event? Enter 1 for open and 0 for closed'
      value = gets.chomp.to_i
      status = Helper_functions.get_status(value)

      puts 'Enter the number of people that can join the event'
      size = gets.chomp.to_i

      File.open(FILE_NAME, 'a') do |events_file|
        Helper_functions.write_to_file(date, events_file, name, size, status)
      end

    when 4
      puts 'Enter the name of event to remove'
      event_name = gets.chomp

      events_directory = Helper_functions.read_file

      selected_events = Helper_functions.find_events(events_directory, event_name)

      if selected_events.size > 1
        puts 'There are ' + selected_events.size.to_s + ' events with the same name. Do you want to delete the 1st one or all of them?'
        puts 'Enter 1 to delete the 1st one and 0 to delete all of them'
        value = gets.chomp.to_i
        bool = false
        until bool
          if value == 1
            index = Helper_functions.find_index(events_directory, event_name)
            events_directory.delete_at(index)
            Helper_functions.overwrite(events_directory)
            bool = true
          elsif value.zero?
            events_directory.reject! { |event| event.name == event_name }
            Helper_functions.overwrite(events_directory)
            bool = true
          else
            puts 'Invalid input. Enter a valid input'
            puts 'Enter 1 to delete the 1st one and 0 to delete all of them'
          end
        end

      else
        index = Helper_functions.find_index(events_directory, event_name)
        events_directory.delete_at(index)
        Helper_functions.overwrite(events_directory)
      end

    when 5
      puts 'Enter the name of event to edit'
      event_name = gets.chomp

      events_directory = Helper_functions.read_file

      selected_events = Helper_functions.find_events(events_directory, event_name)
      if selected_events.size > 1
        puts 'There are ' + selected_events.size.to_s + ' events with the same name. Editing the first one...'
      end

      index = Helper_functions.find_index(events_directory, event_name)
      if events_directory[index].status == 'closed'
        puts 'You cannot edit a closed event'
      else
        puts 'Enter the new name of event'
        new_name = gets.chomp
        puts 'Enter the new date of event in the following format: dd-MM-yyyy'
        new_date = gets.chomp

        Helper_functions.validate_date(date)

        puts 'What is the new status of the event? Enter 1 for open and 0 for closed'
        value = gets.chomp.to_i
        new_status = Helper_functions.get_status(value)

        puts 'Enter the number of people that can join the event'
        new_size = gets.chomp.to_i

        events_directory[index].name = new_name
        events_directory[index].date = new_date
        events_directory[index].status = new_status
        events_directory[index].size = new_size

        Helper_functions.overwrite(events_directory)

      end

    when 6
      File.open(FILE_NAME, 'w') { |file| }

    when 7
      puts 'Enter the name of event to print'
      event_name = gets.chomp

      events_directory = Helper_functions.read_file

      selected_events = events_directory.select { |event| event.name == event_name }
      if selected_events.size > 1
        puts 'There are ' + selected_events.size.to_s + ' events with the same name. Do you want to print the 1st one or all of them?'
        puts 'Enter 1 to print the 1st one and 0 to print all of them'
        value = gets.chomp.to_i
        bool = false
        until bool
          if value == 1
            index = Helper_functions.find_index(events_directory, event_name)
            Helper_functions.print_event(events_directory[index])
            bool = true

          elsif value.zero?
            selected_events.each { |event| Helper_functions.print_event(event) }
            bool = true

          else
            puts 'Invalid input. Enter a valid input'
            puts 'Enter 1 to print the 1st one and 0 to print all of them'
            value = gets.chomp.to_i
          end
        end

      else
        index = Helper_functions.find_index(events_directory, event_name)
        Helper_functions.print_event(events_directory[index])
      end

    when -99
      break

    else
      puts 'Invalid option number. Enter again!'

    end
  end
end
