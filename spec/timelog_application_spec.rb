require "spec_helper"
require_relative "../lib/timelog_application"

RSpec.describe TimelogApplication do
  SPEC_TIMELOG_FILE_NAME = "timelog.txt"

  before do
    File.delete(SPEC_TIMELOG_FILE_NAME) if File.exist?(SPEC_TIMELOG_FILE_NAME)

    log(user: "fred", project: "project-1", hours: 6.0)
    log(user: "jim", project: "project-1", hours: 7.0)
    log(user: "alice", project: "project-1", hours: 4.5)
  end

  after do
    File.delete(SPEC_TIMELOG_FILE_NAME) if File.exist?(SPEC_TIMELOG_FILE_NAME)
  end

  describe "original" do
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
  end

  describe "revised" do
    subject { TimelogApplication.new(SPEC_TIMELOG_FILE_NAME) }

    it "project total" do
      total_hours = subject.total_hours_for_project(project: "project-1")

      expect(total_hours).to eq(17.5)
    end

    it "project total for missing project" do
      total_hours = subject.total_hours_for_project(project: "project-2")

      expect(total_hours).to eq(0)
    end

    it "user total" do
      total_hours = subject.total_hours_for_user(user: "fred", project: "project-1")

      expect(total_hours).to eq(6)
    end

    it "user total for missing user" do
      total_hours = subject.total_hours_for_user(user: "harry", project: "project-1")

      expect(total_hours).to eq(0)
    end

    it "user total for missing project" do
      total_hours = subject.total_hours_for_user(user: "fred", project: "project-2")

      expect(total_hours).to eq(0)
    end
  end

  def log(logging_options)
    timelog_application = TimelogApplication.new(SPEC_TIMELOG_FILE_NAME)
    timelog_application.log(OpenStruct.new(logging_options))
  end

  def report(reporting_options)
    timelog_application = TimelogApplication.new(SPEC_TIMELOG_FILE_NAME)
    timelog_application.report(OpenStruct.new(reporting_options))
  end

end
