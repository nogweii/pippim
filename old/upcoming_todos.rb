require 'rubygems'
require 'vpim'
require 'pp'
require 'facets/ansicode'
require 'facets/enumerable'

Infinity = 1.0/0.0
Todos_Status = ["NEEDS-ACTION", "IN-PROCESS", "COMPLETED", "CANCELLED"]
UID_Regexp = /^(\d)@pippim\.todo$/
cals = Vpim::Icalendar.decode(File.read("rtm_icalendar.ics"))
todos = cals.first.todos.sort_by { |todo| [todo.priority == 0 ? 10 : todo.priority, (todo.due || Infinity).to_f, todo.summary] }.map_with_index { |t, i| [i+1, t] }

todos.each do |i, todo|
	next unless todo.status == "NEEDS-ACTION" or todo.status == nil
	puts "#{i}: #{todo.summary}"
end

puts "-"*80
puts "#{todos.select{|i, t|t.status != "COMPLETED"}.count} in here"

