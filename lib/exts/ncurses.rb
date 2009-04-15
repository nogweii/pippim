require 'ncurses'

module Ncurses
	x,y = [],[]
	Ncurses.getmaxyx(Ncurses.stdscr, y,x)
	COLS = x[0] # Maximum columns (aka the width of the terminal)
	LINES = y[0] # Maximum rows/lines (aka the height of the terminal)

	# Prints +string+ horizontally centered in +stdscr+
	def printmid(starty, startx, string, width=COLS)
		wprintmid(stdscr, starty, startx, string, width)
	end

	# Prints +string+ horizontally centered in +win+
	def wprintmid(win, starty, startx, string, width=COLS)
		x = Array.new
		y = Array.new
		Ncurses.getyx(win, y, x);

		length = string.length;
		x[0] = startx + ((width - length)/ 2).floor;
		win.mvprintw(starty, x[0], "%s", string);
	end

	module_function :printmid, :wprintmid
end
