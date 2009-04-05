class NCCal
	def draw_lines
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
	end

	def draw_dates
		# Draw each date.
		@dayy = @starty
		@dayx = (@xinc * @Tm.padding) + 1
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

	end

	def update
		Ncurses.printmid(0, 0, "#{Date::MONTHNAMES[@Tm.selected.month]} #{@Tm.selected.year}")
		draw_lines
		Ncurses.refresh
		draw_dates
		Ncurses.refresh
	end
end
