#! /usr/bin/ruby
#
# Usage:
#
# timelog [--user USERNAME] [[--date d] [--hours] hrs] project
#

require "ostruct"
require "optparse"
require "optparse/date"

require_relative "timelog_application"

def parse_options(argv)
  options = OpenStruct.new
  OptionParser.new do |opts|
    opts.banner = "Usage: #{$PROGRAM_NAME} [options] project_name"

    opts.on("-d", "--date DATE", Date, "Specify the date on which hours were worked") do |d|
      options.date = d
    end
    opts.on("-h", "--hours NUM", Float, "The number of hours worked") do |hrs|
      options.hours = hrs
    end
    opts.on("-u", "--user USERNAME", String, "Log time for a different user") do |user|
      options.user = user
    end
    opts.on_tail("-?", "--help", "Show this message") do
      puts opts
      exit
    end
  end.parse!

  if argv.length < 1
    puts "Usage: #{$PROGRAM_NAME} [options] project_name"
    exit
  end

  if argv.length == 2
    hours = argv.shift
    options.hours = hours.to_f
  end

  if options.hours && options.hours <= 0.0
    fail OptionParser::InvalidArgument, hours
  end

  options.project = argv[0]
  options
end

TIMELOG_FOLDER = ENV["TL_DIR"] || "/var/log/timelog"
TIMELOG_FILE_NAME = "timelog.txt"
TIMELOG_FILE = TIMELOG_FOLDER + "/" + TIMELOG_FILE_NAME

if __FILE__ == $PROGRAM_NAME
  options = parse_options(ARGV)

  timelog_application = TimelogApplication.new(TIMELOG_FILE)

  if options.hours.nil?
    puts timelog_application.report(options)
  else
    timelog_application.log(options)
  end
end
