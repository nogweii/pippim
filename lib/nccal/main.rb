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

	def change_date(by)
		@Tm.selected += by
		if @Tm.first.month != @Tm.selected.month
			clear_dates
			@Tm.update @Tm.selected.to_time
		end
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
					change_date -1
				when ?j
					change_date  7
				when ?k
					change_date -7
				when ?l
					change_date  1
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
