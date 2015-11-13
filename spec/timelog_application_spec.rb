require "spec_helper"
require_relative "../lib/timelog"
require_relative "../lib/timelog_application"

RSpec.describe TimelogApplication do
  before do
    File.delete(TIMELOG_FILE_NAME) if File.exist?(TIMELOG_FILE_NAME)

    log(options(user: "fred", project: "project-1", hours: 6.0))
    log(options(user: "jim", project: "project-1", hours: 7.0))
    log(options(user: "alice", project: "project-1", hours: 4.5))
  end

  after do
    File.delete(TIMELOG_FILE_NAME) if File.exist?(TIMELOG_FILE_NAME)
  end

  it "project total" do
    reporting_options = options(project: "project-1")

    result = report(reporting_options).split("\n")[-1]

    expect(result.split[1].to_f).to eq(17.5)
  end

  it "project total for missing project" do
    reporting_options = options(project: "project-2")

    result = report(reporting_options).split("\n")[-1]

    expect(result.split[1].to_f).to eq(0)
  end

  it "user total" do
    reporting_options = options(user: "fred", project: "project-1")

    result = report(reporting_options).split("\n")[-1]

    expect(result.split[1].to_f).to eq(6)
  end

  it "user total for missing user" do
    reporting_options = options(user: "harry", project: "project-1")

    result = report(reporting_options).split("\n")[-1]

    expect(result.split[1].to_f).to eq(0)
  end

  it "user total for missing project" do
    reporting_options = options(user: "fred", project: "project-2")

    result = report(reporting_options).split("\n")[-1]

    expect(result.split[1].to_f).to eq(0)
  end

  def log(logging_options)
    timelog_application = TimelogApplication.new(TIMELOG_FILE_NAME)
    timelog_application.log(logging_options)
  end

  def report(reporting_options)
    timelog_application = TimelogApplication.new(TIMELOG_FILE_NAME)
    timelog_application.report(reporting_options)
  end

  def options(opts)
    OpenStruct.new(opts)
  end

end
