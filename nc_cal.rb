#!/usr/bin/ruby

require 'ncurses'
require 'lib/nccal/time_manager.rb'

@Tm = NCCal::TimeManager.new

begin
	@window = Ncurses.initscr # Start curses mode
	require 'lib/ncurses_exts.rb'
	Ncurses.cbreak
	Ncurses.noecho
	Ncurses.keypad(@window, true)
	Ncurses.curs_set(0) # Goodbye, cursor

	# Quick calculations for the maximum/width height of both the main
	# window, but also of the calendar itself.
	@calheight = Ncurses::LINES-4
	@starty = Ncurses::LINES-@calheight
	@xinc = (Ncurses::COLS/7) # always 7 visible week days
	@yinc = (@calheight)/6 # always 6 visible weeks

	# Start the actual drawing
	Ncurses.printmid(0, 0, "#{Date::MONTHNAMES[@Tm.selected.month]} #{@Tm.selected.year}")
	# Draw vertical lines (along the X axis)
	@wday = 1
	while (@xinc*@wday) <= Ncurses::COLS
		Ncurses.mvvline(@starty, (@xinc*@wday), 0, @calheight-2) unless @wday == 7
		@calwidth = (@xinc*(@wday-1))+1
		Ncurses.printmid(3, @calwidth, Date::DAYNAMES[@wday-1], @xinc)
		@wday += 1
	end
	@calwidth += @xinc-1

	# Draw horizontal lines (along the Y axis)
	@week = 1
	while (@yinc*@week) < @calheight-@yinc
		Ncurses.mvhline((@yinc*@week)+3, 2, 0, @calwidth)
		@week += 1
	end

	# Draw each date.
	@dayy = @starty
	@dayx = (@xinc * @Tm.first_padding) + 1
	@current = @Tm.first.dup
	while (@current.day <= @Tm.last.day and @current.month == @Tm.last.month)
		if @Tm.selected.day == @current.day
			Ncurses.attron(Ncurses::A_REVERSE)
		end
		Ncurses.mvaddstr(@dayy, @dayx, ("%2s" % @current.day))
		if @Tm.selected.day == @current.day
			Ncurses.attroff(Ncurses::A_REVERSE)
		end
		@dayx = @xinc * (@current.wday+1) + 1
		if @current.wday == 6
			@dayy += @yinc
			@dayx = 2
		end
		@current += 86400
	end
	
	Ncurses.refresh(); # Print it on to the real screen

	while ((ch = @window.getch()) != ?q) do
		case ch
		when ?h
			# move left
		else
			# default
		end
	end
ensure
	Ncurses.endwin(); # End curses mode
end
