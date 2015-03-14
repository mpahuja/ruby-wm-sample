# Gems
require 'rubygems'
require 'selenium-webdriver'
require 'net/pop'
require 'properties-ruby'
require 'yaml'
require 'rspec_junit_formatter'
require 'yarjuf'
require 'rest_client'

#rSpec
require 'logger'
require 'rspec/core'
require 'rspec/expectations'
require 'rspec/matchers'
require 'logging'
require 'rspec/logging_helper'
require 'ostruct'
require 'json'
require 'allure-rspec'
require 'uuid'
require 'rspec/retry'
require "net/http"
require "benchmark"
require 'rspec/legacy_formatters'
require 'rspec/core/formatters/documentation_formatter'

require File.expand_path('lib/common/webdriverconnector.rb')
require File.expand_path('lib/common/log_util.rb')
Dir[File.expand_path('lib/common/*.rb')].each { |f| require f }
require File.expand_path('lib/pageobjects/object_classes.rb')
Dir[File.expand_path('lib/pageobjects/*.rb')].each { |f| require f }

require File.expand_path('lib/common/yaml_properties_holder.rb')
require File.expand_path('lib/common/failures_formatter.rb')

Dir[File.expand_path('lib/helpers/*.rb')].each { |f| require f }
require File.expand_path('lib/helpers/search_helper.rb')
require File.expand_path('lib/helpers/product_helper.rb')

RSpec.configure do |config|
  config.include Walmart::Mobile::HomePage
  config.include Walmart::Mobile::SearchHelper
  config.include Walmart::Mobile::ProductHelper
  config.include Walmart::Mobile::ProductDetails
  config.include Walmart::Mobile::CartPage
  config.include Walmart::Mobile::SignInHelper
  config.include Walmart::Mobile::ShippingOptions
  config.include Walmart::Mobile::ShipInfoHelper
  config.include Configuration
  config.include Constants
  config.include Strings
  config.include SeleniumWebdriver::WebDriverConnector
  config.include Log_Util
  config.include PropertiesHelper
  config.include YAMLPropertiesHolder
  config.include AllureRSpec::Adaptor
  config.verbose_retry = true
  config.add_formatter RSpec::Core::Formatters::DocumentationFormatter
end

AllureRSpec.configure do |c|
  c.output_dir = "log/screenshots"
  c.clean_dir = false
end
