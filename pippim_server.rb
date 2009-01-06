#!/usr/bin/ruby

require 'rubygems'
require 'icalendar'
require 'lib/yaml'

unless File.exists?(File.config_path("config"))
	puts "Please run `rake setup' before running this!"
end

events = []
Dir[File.config_path("calendars")].each do |calfile|
	Icalendar.parse(File.read(calfile)).each do |cal|
		cal.events.each do |event|
			events << event
		end
	end
end
today = Date.today
events = events.map{|event| event.dtend.day if event.dtend and event.dtend.month == today.month }.select {|days| not days.nil? }.sort.uniq

require 'drb'

DRb.start_service nil, events

druby = File.join(File.config_path("config"), "druby")

f = File.open(druby, "w+")
f.puts(DRb.uri.to_s)
f.close

trap :INT, proc { puts "Killing DRb server..."; DRb.thread.kill }
DRb.thread.join

File.unlink druby
