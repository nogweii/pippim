#!/usr/bin/ruby

require 'ncurses'
require 'date'

def print_in_middle(string, starty, startx, width=80, win=Ncurses.stdscr, color=nil)

  if(win == nil)
    win = Ncurses.stdscr;
  end
  x = Array.new
  y = Array.new
  Ncurses.getyx(win, y, x);

  if(startx != 0)
    x[0] = startx;
  end

  if(starty != 0)
    y[0] = starty;
  end

  if(width == 0)
    width = 80;
  end

  length = string.length;
  temp = (width - length)/ 2;
  x[0] = startx + temp.floor;
  win.attron(color) if color
  win.mvprintw(y[0], x[0], "%s", string);
  win.attroff(color) if color
  Ncurses.refresh();
end

now = Time.now
last = (Time.mktime(now.year+now.month.div(12), (now.month%12)+1, 1) - 86400)
first_padding = (last.wday - last.day+1)%7
first = Time.mktime(now.year+now.month.div(12), (now.month%12), 1)
weeks = last.day/7
weeks += 1 if last.day%7 + first.wday >= 7
selected = Date.today

begin
	window = Ncurses.initscr # Start curses mode
	Ncurses.cbreak
	Ncurses.noecho
	Ncurses.keypad(window, true)
	Ncurses.curs_set(0) # Goodbye, cursor
	width,height = [],[]
	Ncurses.getmaxyx(window, height,width);
	height,width = height[0],width[0]
	print_in_middle("April 2009", 0, 0, width)
	calheight = height-4

	starty = height-calheight
	#staryx = 
	xinc = (width/7) # always 7 visible week days
	yinc = (calheight)/6 # always 6 visible weeks

	# Draw vertical lines (along the X axis)
	wday = 1
	while (xinc*wday) <= width
		Ncurses.mvvline(starty, (xinc*wday), 0, calheight-2) unless wday == 7
		calwidth = (xinc*(wday-1))+1
		print_in_middle(Date::DAYNAMES[wday-1], 3, calwidth, xinc)
		wday += 1
	end
	calwidth += xinc-1

	# Draw horizontal lines (along the Y axis)
	week = 1
	while (yinc*week) < calheight-yinc
		Ncurses.mvhline((yinc*week)+3, 2, 0, calwidth)
		week += 1
	end

	dayy = starty
	dayx = xinc*first_padding+1
	current = first.dup
	while (current.day <= last.day and current.month == last.month)
		if selected.day == current.day
			Ncurses.attron(Ncurses::A_REVERSE)
		end
		Ncurses.mvaddstr(dayy, dayx, ("%2s" % current.day))
		if selected.day == current.day
			Ncurses.attroff(Ncurses::A_REVERSE)
		end
		dayx = xinc * (current.wday+1) + 1
		if current.wday == 6
			dayy += yinc
			dayx = 2
		end
		current += 86400
	end
	
	Ncurses.refresh(); # Print it on to the real screen

	while ((ch = window.getch()) != ?q) do
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

__END__

	dayy = 2
	current = first.dup
	while (current.day <= last.day and current.month == last.month)
		Ncurses.mvaddstr(dayy, dayx, ("%2d" % current.day))
		dayx += xinc
		if current.wday == 6
			dayy += yinc
			dayx = 1
		end
		current += 86400
	end



print "   " * first_padding
current = first.dup
while current.day <= last.day
	print "%3s" % current.day
	print "\n" if current.wday == 6
	if current.day == last.day
		puts "   " * (7-last.wday)
		break
	end
	current += 86400
end
