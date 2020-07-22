require 'date'
require_relative 'events.rb'

module Helper_functions

  FILE_NAME = 'events.txt'.freeze

  def self.print_event(event)
    puts "Name of the event :  #{event.name}"
    puts "Date of the event :  #{event.date}"
    puts "Status of the event: #{event.status}"
    puts "Size of the event :  #{event.size}"
    puts ''
  end

  def self.print_calendar(date, events_hash)
    days_of_week = Date::ABBR_DAYNAMES.map { |x| " #{x}" }
    month_name = Date::ABBR_MONTHNAMES[date.month]
    year_month_str = "#{date.year} - #{month_name}"
    cell_length = days_of_week.first.length + 5
    line_length = cell_length * days_of_week.length
    padding = line_length / 2 - year_month_str.length / 2

    puts year_month_str.rjust(year_month_str.length + padding, ' ')
    puts days_of_week.join('     ')

    curr_week_day = date.wday
    curr_month = date.month

    prev_padding = ''.ljust(curr_week_day * cell_length, ' ')

    while date.month == curr_month
      while curr_week_day < days_of_week.length and date.month == curr_month
        if events_hash[date.day].zero?
          day_string = date.day.to_s.rjust(cell_length, ' ')
        else
          date_string = date.day.to_s + '(' + events_hash[date.day].to_s + ')*'
          day_string = date_string.rjust(cell_length, ' ')
        end
        cell = "#{prev_padding}#{day_string}"

        prev_padding = ''
        print cell

        date += 1
        curr_week_day += 1
      end
      curr_week_day = 0
      puts
    end
  end

  def self.write_to_file(date, events_file, name, size, status)
    events_file.puts name.to_s
    events_file.puts date.to_s
    events_file.puts status.to_s
    events_file.puts size.to_s
    events_file.puts ''
  end

  def self.read_file()
    events_directory = []
    File.open(FILE_NAME, 'r') do |events_file|

      until events_file.eof?
        name = events_file.readline.chomp.to_s
        date = events_file.readline.chomp.to_s
        status = events_file.readline.chomp.to_s
        size = events_file.readline.chomp.to_s
        space = events_file.readline
        date = Date.strptime(date, '%Y-%m-%d')

        events_directory.push(Events.new(name, date, status, size))
      end
    end

    events_directory
  end

  def self.overwrite(events_directory)
    File.open(FILE_NAME, 'w') do |events_file|
      events_directory.each { |event| write_to_file(event.date, events_file, event.name, event.size, event.status) }
    end
  end

  def self.populate_hash
    events_hash = {}
    i = 1
    while i < 32
      events_hash.store(i, 0)
      i += 1
    end
    events_hash
  end

  def self.validate_date(date)
    bool = false

    until bool
      begin
        d, m, y = date.split '-'
        if Date.valid_date? y.to_i, m.to_i, d.to_i
          date = Date.strptime(date, '%d-%m-%Y')
          bool = true
        else
          puts 'Invalid Date. Enter Date again'
          date = gets.chomp
        end
      rescue StandardError
        puts 'Invalid Date format. Enter Date again'
        date = gets.chomp
      end
    end

  end

  def self.get_status(value)
    bool = false
    until bool
      if value == 1
        bool = true
        return 'open'
      elsif value.zero?
        bool = true
        return 'closed'
      else
        puts 'Invalid input. Enter a valid input'
        puts 'Enter 1 to print the 1st one and 0 to print all of them'
        value = gets.chomp.to_i
      end
    end
  end

  def self.find_index(events_directory, event_name)
    events_directory.find_index { |event| event.name == event_name }
  end

  def self.print_month(events_directory, date)
    selected_events = events_directory.select { |event| event.date.month == date.month and event.date.year == date.year }

    events_hash = populate_hash

    selected_events.each { |event| events_hash[event.date.day.to_i] += 1 }

    print_calendar(date, events_hash)
  end

  def self.find_events(events_directory, event_name)
    events_directory.select { |event| event.name == event_name }
  end

end
