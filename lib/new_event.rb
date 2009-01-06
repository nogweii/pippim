#!/usr/bin/ruby

# Sample code to take a file formatted similarly to event.template and create an iCalendar VEVENT (using the Icalendar library)

require 'rubygems'
require 'icalendar'
require 'chronic'
require 'fileutils'
require 'lib/yaml'
require 'pp'

# Copy the template to a tmp file & have the user edit it
tmp_file = File.join(ENV['TMP'] || ENV['TEMP'] || "/tmp", "ical.event.#{$$}")
FileUtils.cp File.config_path('template'), tmp_file
system("#{ENV['EDITOR'] || 'vim'} #{tmp_file}")

# Start parsing the file
lines = File.readlines(tmp_file).map(&:strip)
begin_desc = lines.index(lines.grep(/^[-=]+$/).first)
if not begin_desc.nil? and begin_desc > 0
	description = lines[begin_desc+1..-1]
else
	puts "No marker for beginning of description! (Try adding '---' in a seperate line before the beginning of the description)"
	exit 1
end

meta = lines[0..(-2-description.size)]
event = Icalendar::Event.new
event.description description

# Meta mess - each line is treated as a method name.
# Can prove dangerous, but who would want to wreck their own calendar?
meta = meta.map {|line| line.split(':').map(&:strip)}.map {|ary| [ary[0].strip.downcase, ary[1..-1].join(':').strip]}
meta.each do |ary|
	case ary[0]
	when "categories"
		ary[1] = ary[1].gsub(/[^A-Za-z0-9 ]/, '').split.map(&:upcase)
	when "date"
		ary[1] = Chronic.parse(ary[1])
		if ary[1].nil?
			puts "Invalid date format"
			exit 1
		end
		ary[1] = Date.parse(ary[1].to_s)
		ary[0] = "dtend" # dtstart? Which?!?
	end
	event.method(ary[0]).call(ary[1])
end


# Now actually start saving the changes

# Check if the calendar file exists...
unless File.exists? File.config_path("personal_cal")
	FileUtils.touch File.config_path("personal_cal")
end
# Check if the file has any calendars before
cals = Icalendar.parse File.read(File.config_path("personal_cal"))
cal = cals.empty? ? Icalendar::Calendar.new : cals.first
cal.add_event(event)

# Regen the iCalendar strings & overwrite the file with the new ones
ical_string = cal.to_ical
cals[1..-1].each do |calendar|
	ical_string << "\n"
	ical_string << calendar.to_ical
end if cals[1..-1]
cal_file = File.open(File.config_path("personal_cal"), "w")
cal_file.puts ical_string

# Cleanup
cal_file.close
FileUtils.rm tmp_file
