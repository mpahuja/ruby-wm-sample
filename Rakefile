##!/usr/bin/env rake
## Add your own tasks in files placed in lib/tasks ending in .rake,
## for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.
#
#
require File.expand_path('../config/application', __FILE__)
require 'rspec/core/rake_task'
require_relative 'lib/common/failures_formatter'

def gather_failures
  opts = ""
  files = Dir.glob('*.failures')
  files.each { |file| opts << File.read(file).gsub(/\n/, ' ') }
  all_failures = './all.failures'
  File.write(all_failures, opts.rstrip)
  return File.read all_failures
end

def cleanup(files = '')
  puts "Deleting all failure files"
  system("rm #{files}") unless Dir.glob("#{files}").empty?
end

def delete_initial_run_files
  puts "Deleting all screenshot and .xml file from the initial run"
  system("rm -rf log/reports/*")
  system("rm -rf log/screenshots/*")
end

def generate_report
  puts "Generating report"
  report = "log/screenshots -o log/reports"
  system("allure generate #{report}")
end

def launch(params = {})
  if params[:test_options].include? '-e'
    count = params[:test_options].split(/failed/).count - 1
  end
  system("parallel_rspec -n #{params[:processes] || 5} \
    --test-options '#{params[:test_options]}' --serialize-stdout \
    #{params[:spec_file_pattern]}")
end

def first_run(spec_file_pattern)
  puts spec_file_pattern
  launch(processes: "5".to_i,
         test_options: "--require ./lib/common/failures_formatter.rb \
    --format FailureCatcher", spec_file_pattern: spec_file_pattern)
end

def rerun(spec_file_pattern)
  launch(processes: "5".to_i, test_options: "--require ./lib/common/re_run_data_collector.rb \
    --format ReRunDataCollector #{gather_failures}", spec_file_pattern: spec_file_pattern)
end

# To-Do Add processes as an argument to also pass number of processes as an argument
desc "parallel test execution with failure retries"
task :run_tests, [:spec_file_pattern] do |t, args|
  cleanup '*.failures'
  first_run args[:spec_file_pattern.to_s]
  puts "Before re-run #{$?.to_s}"
  if $?.success? == false
    delete_initial_run_files
    rerun args[:spec_file_pattern.to_s]
    puts "After re-run #{$?.to_s}"
    if $?.success? == false
      generate_report
      cleanup '*.failures'
      raise "Rerun still had failing tests"
    else
      generate_report
      cleanup '*.failures'
      puts "Rerun resulted in all passing"
    end
  else
    generate_report
    puts "All tests passed in the first run"
  end
end