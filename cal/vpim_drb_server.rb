#!/usr/bin/ruby

require 'rubygems'
require 'vpim/repo'

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
puts DRb.uri
DRb.thread.join
