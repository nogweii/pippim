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

			update

			while ((ch = @window.getch()) != ?q) do
				case ch
				when ?h
					@Tm.selected -= 1
				when ?j
					@Tm.selected += 7
				when ?k
					@Tm.selected -= 7
				when ?l
					@Tm.selected += 1
				else
					Ncurses.refresh
				end
				update
			end
		ensure
			Ncurses.endwin(); # End curses mode
		end
	end
end
