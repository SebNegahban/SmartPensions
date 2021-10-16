#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/log_parser'
require_relative '../lib/exceptions/log_error'

if ARGV.empty?
  puts 'You need to provide a log file!'
  exit 1
end

begin
  LogParser.new(ARGV[0]).parse_log
rescue LogError => e
  puts e.message
end
