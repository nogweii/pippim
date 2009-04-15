#!/usr/bin/ruby

begin
	require 'ncurses'
rescue LoadError
	require 'rubygems'
	require 'ncurses'
end
require 'lib/nccal/time_manager.rb'
require 'lib/nccal/main.rb'

NCCal.new.loop
