require 'rspec/core/formatters/base_formatter'
require 'allure-ruby-adaptor-api/builder'
require 'rspec/core/example'
require_relative '../../spec/spec_helper'

class ReRunDataCollector < RSpec::Core::Formatters::BaseFormatter

  # def start_dump
  #   examples.each { |example| post_test_data_to_logstash(example,true) }
  # end
end