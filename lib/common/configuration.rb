require_relative '../common/constants'

module Configuration

  props = Utils::Properties.load_from_file (File.absolute_path(Constants::CONFIG_PROPERTIES))
  prop1= props.get(:TESTS_RUNNER,true)
  prop2= props.get(:ENV,true)
  prop3= props.get(:LOG_LEVEL, true)

  @tests_runner = prop1.to_sym
  @env= prop2.to_s
  @log_level = prop3.to_s

  def self.log_level
    @log_level
  end

  def self.tests_runner
    @tests_runner
  end

  def self.env
    @env
  end
end
