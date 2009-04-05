require 'lib/nccal/draw.rb'

class NCCal
	def setup
		@Tm = NCCal::TimeManager.new
		@window = Ncurses.initscr # Start curses mode
		require 'lib/ncurses_exts.rb'
		Ncurses.cbreak
		Ncurses.noecho
		Ncurses.keypad(@window, true)
		Ncurses.curs_set(0) # Goodbye, cursor
	end

	def loop
		begin
			setup

			# Quick calculations for the maximum/width height of both the main
			# window, but also of the calendar itself.
			@calheight = Ncurses::LINES-4
			@starty = Ncurses::LINES-@calheight
			@xinc = (Ncurses::COLS/7) # always 7 visible week days
			@yinc = (@calheight)/6 # always 6 visible weeks

			draw_lines
			Ncurses.refresh
			draw_dates
			Ncurses.refresh

			# Start the actual drawing
			Ncurses.printmid(0, 0, "#{Date::MONTHNAMES[@Tm.selected.month]} #{@Tm.selected.year}")

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
	end
end
