require_relative '../../lib/common/constants'
require_relative '../../lib/common/configuration'
require 'ostruct'
require 'json'
require 'yaml'

module PropertiesHelper

  attr_accessor :log_level, :browser_version, :remote_machine_ip, :driver_type, :email_address, :email_password,
                :use_parallel, :app_url, :street_address_1, :street_address_2, :zip_code, :city, :phone_number, :state

  def initialize
    data = YAML.load_file(File.expand_path("config/data/data_#{Configuration.tests_runner}.yml"))[Configuration.env]

    common_data  = OpenStruct.new(data['common'])
    env_data  = OpenStruct.new(data['envdata'])

    @log_level = common_data.log_level
    @use_parallel = common_data.use_parallel
    @browser_version = common_data.browser_version.to_sym
    @driver_type = common_data.driver_type
    @remote_machine_ip = common_data.remote_machine_ip
    @street_address_1 = common_data.street_address_1
    @street_address_2 = common_data.street_address_1
    @zip_code = common_data.zip_code
    @city = common_data.city
    @state = common_data.state
    @phone_number = common_data.phone_number

    @email_address = env_data.email_address
    @email_password = env_data.email_password
    @app_url = env_data.app_url

  end
end






