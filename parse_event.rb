#!/usr/bin/ruby

# Sample code to take a file formatted similarly to event.template and create an iCalendar VEVENT (using the Icalendar library)

require 'rubygems'
require 'icalendar'
require 'chronic'

lines = File.readlines("event.template").map(&:strip)

begin_desc = lines.index(lines.grep(/^[-=]+$/).first)
if not begin_desc.nil? and begin_desc > 0
	description = lines[begin_desc+1..-1]
else
	puts "No marker for beginning of description! (Try adding '---' in a seperate line before the beginning of the description)"
	exit 1
end

meta = lines[0..(-2-description.size)]
event = Icalendar::Event.new

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
		ary[0] = "dtend" # dtstart? Which?!?
	end
	event.method(ary[0]).call(ary[1])
end

cal = Icalendar::Calendar.new
cal.add_event(event)
puts cal.to_ical
