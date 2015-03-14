require 'rspec/core/formatters/base_formatter'
require 'allure-ruby-adaptor-api/builder'
require 'rspec/core/example'
require_relative '../../spec/spec_helper'

class FailureCatcher < RSpec::Core::Formatters::BaseFormatter

  def dump_failures
    return if failed_examples.empty?
    f = File.new("rspec#{ENV['TEST_ENV_NUMBER']}.failures", "w+")
    failed_examples.each do |example|
      f.puts retry_command(example)
    end
    f.close
  end

  # def start_dump
  #   examples.each { |example| post_test_data_to_logstash(example,false) }
  # end

  def retry_command(example)
    example_name = example.full_description.gsub("\"", "\\\"")
    "-e \"#{example_name}\""
  end
end