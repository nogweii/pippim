#!/usr/bin/ruby

begin
	require 'ncurses'
rescue LoadError
	require 'rubygems'
	require 'ncurses'
end

require 'exts/date_time'
require 'nccal/time_manager'
require 'nccal/main'

NCCal.new.loop
