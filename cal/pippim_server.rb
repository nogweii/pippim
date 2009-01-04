#!/usr/bin/ruby

require 'rubygems'
require 'vpim/repo'

unless File.exists?(conf_dir = File.join("#{ENV['HOME']}", ".config", "pippim"))
	puts "making dir..."
	Dir.mkdir conf_dir
end

vrd = Vpim::Repo::Directory.new("#{Dir.pwd}/calendars")
events = []
vrd.each do |cal|
	cal.events do |event|
		events << event
	end if cal.displayed # Better method name would've been 'displayed?'
end
today = Date.today
events = events.map{|event| event.dtend.day if event.dtend and event.dtend.month == today.month }.select {|days| not days.nil? }.sort.uniq

require 'drb'

DRb.start_service nil, events

druby = File.join(conf_dir, "druby")

f = File.open(druby, "w+")
f.puts(DRb.uri.to_s)
f.close

trap :INT, proc { puts "Killing DRb server..."; DRb.thread.kill }
DRb.thread.join

File.unlink druby
