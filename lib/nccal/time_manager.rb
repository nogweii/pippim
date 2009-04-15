require 'time'
require 'date'

class Time
	# Converts a Time object to an instance of Date.
	#
	# Credit goes to the ActiveSupport team.
	def to_date
		::Date.new(year, month, day)
	end
end

class Date
	# Converts a Date object to an instance of Time.
	#
	# Credit goes to the ActiveSupport team.
	def to_time(form = :local)
		::Time.send("#{form}", year, month, day)
	end
end

class NCCal
	class TimeManager # < Struct.new(:now, :first, :last, :selected)
		attr_reader :now, :weeks, :last, :first, :padding
		attr_accessor :selected

		def initialize(time=Time.now)
			update(time)
		end

		def update(time)
			raise ArgumentError, "Invalid parameter - TimeManager#update() requires an instance of Time" unless time.is_a? Time
			@now = time
			@last = (Time.mktime(@now.year+@now.month.div(12), (@now.month%12)+1, 1) - 86400)
			@padding = (@last.wday - @last.day+1)%7
			month = @now.month%12
			year = @now.year+@now.month.div(12)
			if month == 0
				month = 12
				year -= 1
			end
			@first = Time.mktime(year, month, 1)
			@weeks = @last.day/7
			@weeks += 1 if @last.day%7 + @first.wday >= 7
			@selected = Date.ordinal(time.year, time.yday)
		end
	end
end
