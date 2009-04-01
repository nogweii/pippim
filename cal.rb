#!/usr/bin/ruby
Thread.abort_on_exception = true

if ARGV.at(0) == "-n"
	# Automatically starts due to no __FILE__ == $0 check
	require 'lib/new_event'
elsif %w[-help --help -h -?].include? ARGV.at 0
	puts <<EOHELP
#{$0} version 0.2
A PipPIM DRb calendar client
USAGE: #{$0} [-n] [-h|--help]
	-h,--help	Display this message
	-n		Create a new event
EOHELP
	exit 1
end

require 'date'
require 'lib/ansicode'
require 'drb'
require 'lib/config'

unless File.exists?(druby = File.config_path("druby"))
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
view.sub!(/#{now.strftime("%e")}/, ANSICode.negative(now.strftime('%e')))
dates.each do |date|
	if date < 10
		view.sub!(" #{date}", ANSICode.red(" #{date}"))
	else
		view.sub!(date.to_s, ANSICode.red("#{date}"))
	end
end
puts now.strftime("%B %Y").center(20), "Su Mo Tu We Th Fr Sa", view

