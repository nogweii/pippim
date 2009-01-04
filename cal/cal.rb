#!/usr/bin/ruby

# Finally! The culmination of all my work on VPIM, ical, DRb and cal-clones combined!

#require 'rubygems'
#require 'vpim/repo'
require 'date'
require 'facets/ansicode'
require 'drb'
require 'pp'

unless File.exists?(druby = File.join(ENV['HOME'], ".config", "pippim", "druby"))
	puts "Start the PipPIM server before running this application!"
	exit 1
end

DRb.start_service
dates = DRbObject.new nil, File.readlines(druby).first

now   = Time.now
month = now.month
year  = now.year
stop  = (Time.mktime(year+month.div(12), (month%12)+1, 1) - 86400)
str   = "   "*((stop.wday-stop.day+1)%7)+" 1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 "[0,stop.day*3]
view  = str.gsub(/(.{20})./, "\\1\n")
# sub vs gsub: sub only does the first (rather than all), thus we require a
# sorted array to prevent the wrong numbers from being highlighted
view.sub!(/#{now.strftime("%e")}/, ANSICode.red(now.strftime('%e')))
dates.each do |date|
	view.sub!(/#{date}/, ANSICode.red(date.to_s))
end

# wdays = Date::DAYNAMES.map{ |day| day[0..1] }.join(" ")
puts now.strftime("%B %Y").center(20), "Su Mo Tu We Th Fr Sa", view

