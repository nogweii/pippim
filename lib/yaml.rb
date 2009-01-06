# Extensions to help increase the DRYness of PipPIM
#
# These relate to the YAML configuration of PipPIM

require 'yaml'

# It's a global, sue me. Assumes that 'conf.yaml' is in the parent directory
$YAML = YAML.load(File.read(File.expand_path(File.join(File.dirname(__FILE__), "..", "conf.yaml"))))

# Using the YAML configuration file, gets the absolute path for a configuration
# key.
def File.config_path(key)
	if [?/, ?~].include? $YAML[key][0]
		absolute = $YAML[key]
	else
		absolute = File.join(File.config_path("config"), $YAML[key])
	end

	File.expand_path absolute
end
