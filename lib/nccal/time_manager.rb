require 'time'
require 'date'

class NCCal
	class TimeManager # < Struct.new(:now, :first, :last, :selected)
		attr_reader :now, :weeks, :last, :first, :padding
		attr_accessor :selected

		def initialize(time=Time.now)
			update(time)
		end

		def update(time)
			@now = time
			@last = (Time.mktime(@now.year+@now.month.div(12), (@now.month%12)+1, 1) - 86400)
			@padding = (@last.wday - @last.day+1)%7
			@first = Time.mktime(@now.year+@now.month.div(12), (@now.month%12), 1)
			@weeks = @last.day/7
			@weeks += 1 if @last.day%7 + @first.wday >= 7
			@selected = Date.ordinal(time.year, time.yday)
		end
	end
end
