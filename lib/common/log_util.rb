require_relative '../../spec/spec_helper'
require 'logging'

module Log_Util

  Logging.init :debug, :info, :error

  Logging.appenders.stdout(
      'stdout',
      :layout => Logging.layouts.pattern(
          :pattern => '[%d] %-5l %c: %m\n',
      )
  )
  Logging.logger.root.appenders = Logging.appenders.stdout

  @@log = Logging.logger["WSB"]
  @@log.level = Configuration.log_level

  def log_setup_step(method_name, string)
    @@log.info("Setup Step: ---------------#{string}--------------- : #{method_name} ", )
  end

  def log_start_test(method_name)
    @@log.info('    ')
    @@log.info('=============================================================')
    @@log.info("Starting Test :--- #{method_name}")
  end

  def log_complete_test(method_name)
    @@log.info("Completed Test :--- #{method_name}")
    @@log.info('=============================================================')
    @@log.info('    ')
    @@log.info('    ')
  end

  def log_test_step(string)
    @@log.info("Test Step: -- #{string}")
  end

  def log_test_verify(string)
    @@log.info("---- Verified : #{string}")
  end

  def log_method_step(method_name, string)
    @@log.info("#{string} : -- #{method_name} -- ")
  end

  def log_method_step_debug(method_name, string)
    @@log.debug("#{string} : -- #{method_name} -- ")
  end

  def log_assertion_failed(method_name, string)
    @@log.info("FAILURE: #{string} : -- #{method_name} -- ")
  end

  def log_assertion_passed(method_name, string)
    @@log.info("Success: #{string} : -- #{method_name} -- ")
  end

  def log_error(method_name, string)
    @@log.error("ERROR: #{string} : -- #{method_name} -- ")
  end

end