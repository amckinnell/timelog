require "spec_helper"
require_relative "../lib/timelog_application"

RSpec.describe TimelogApplication do
  TIMELOG_FILE_NAME = "timelog.txt"

  before do
    File.delete(TIMELOG_FILE_NAME) if File.exist?(TIMELOG_FILE_NAME)

    log(user: "fred", project: "project-1", hours: 6.0)
    log(user: "jim", project: "project-1", hours: 7.0)
    log(user: "alice", project: "project-1", hours: 4.5)
  end

  after do
    File.delete(TIMELOG_FILE_NAME) if File.exist?(TIMELOG_FILE_NAME)
  end

  it "project total" do
    result = report(project: "project-1").split("\n")[-1]

    expect(result.split[1].to_f).to eq(17.5)
  end

  it "project total for missing project" do
    result = report(project: "project-2").split("\n")[-1]

    expect(result.split[1].to_f).to eq(0)
  end

  it "user total" do
    result = report(user: "fred", project: "project-1").split("\n")[-1]

    expect(result.split[1].to_f).to eq(6)
  end

  it "user total for missing user" do
    result = report(user: "harry", project: "project-1").split("\n")[-1]

    expect(result.split[1].to_f).to eq(0)
  end

  it "user total for missing project" do
    result = report(user: "fred", project: "project-2").split("\n")[-1]

    expect(result.split[1].to_f).to eq(0)
  end

  def log(logging_options)
    timelog_application = TimelogApplication.new(TIMELOG_FILE_NAME)
    timelog_application.log(OpenStruct.new(logging_options))
  end

  def report(reporting_options)
    timelog_application = TimelogApplication.new(TIMELOG_FILE_NAME)
    timelog_application.report(OpenStruct.new(reporting_options))
  end

end
