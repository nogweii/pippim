desc 'Copy files to the configured directory'
task :setup do
	require 'lib/config'
	unless File.exists? File.config_path("config")
		Dir.mkdir File.config_path("config")
	end
	cp "event.template", File.config_path("template")
	cp_r "calendars", File.config_path("calendars")
end

desc 'Run nccal.rb with a modified library path'
task :nccal do
	exec "ruby -I#{File.join(Dir.pwd, 'lib')} nccal.rb"
end
