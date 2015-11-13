require "spec_helper"
require_relative "../lib/timelog"
require_relative "../lib/timelog_application"

RSpec.describe TimelogApplication do
  before do
    @timelog_size = File.size(TIMELOG_FILE) if File.exist?(TIMELOG_FILE)
    File.delete(TIMELOG_FILE_NAME) if File.exist?(TIMELOG_FILE_NAME)
    ENV["TL_DIR"] = "."
    expect(`ruby lib/timelog.rb -u fred -h 6 project-1`).to eq("")
    expect(`ruby lib/timelog.rb -u jim -h 7 project-1`).to eq("")
    expect(`ruby lib/timelog.rb -u alice -h 4.5 project-1`).to eq("")
  end

  after do
    if File.exist?(TIMELOG_FILE)
      expect(@timelog_size).to eq(File.size(TIMELOG_FILE)), "log file #{TIMELOG_FILE} should be unchanged"
    end
    File.delete(TIMELOG_FILE_NAME) if File.exist?(TIMELOG_FILE_NAME)
  end

  it "project total" do
    rpt = run("project-1").split("\n")[-1]
    expect(rpt.split[1].to_f).to eq(17.5)
  end

  it "project total for missing project" do
    rpt = run("project-2").split("\n")[-1]
    expect(rpt.split[1].to_f).to eq(0)
  end

  it "user total" do
    rpt = run("--user fred project-1").split("\n")[-1]
    expect(rpt.split[1].to_f).to eq(6)
  end

  it "user total for missing user" do
    rpt = run("--user harry project-1").split("\n")[-1]
    expect(rpt.split[1].to_f).to eq(0)
  end

  it "user total for missing project" do
    rpt = run("--user fred project-2").split("\n")[-1]
    expect(rpt.split[1].to_f).to eq(0)
  end

  def run(options)
    `ruby lib/timelog.rb #{options}`
  end

  def log(logging_options)
    timelog_application = TimelogApplication.new(TIMELOG_FILE_NAME)
    timelog_application.log(logging_options)
  end

  def report(reporting_options)
    timelog_application = TimelogApplication.new(TIMELOG_FILE_NAME)
    timelog_application.report(reporting_options)
  end

end
