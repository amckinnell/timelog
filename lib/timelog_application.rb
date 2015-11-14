class TimelogApplication
  def initialize(timelog_filename)
    @timelog_filename = timelog_filename
  end

  def report(options)
    records = read(options)

    months = Hash.new(0.0)
    total = 0.0
    records.each do |record|
      _project, _user, date, hours = record.split(/,/)
      total += hours.to_f
      y, m, _d = date.split(/-/)
      months["#{y}-#{m}"] += hours.to_f
    end

    lines = months.keys.sort.map do |month|
      format("%-7s %8.1f", month, months[month])
    end

    lines << format("Total   %8.1f", total)
    lines.join("\n")
  end

  def total_hours_for_project(project:)
    total_hours(read_for_project(project))
  end

  def total_hours_for_user(user:, project:)
    total_hours(read_for_user(user, project))
  end

  def total_hours(records)
    records.reduce(0.0) do |total, record|
      total + hours(record)
    end
  end

  def hours(record)
    record.split(/,/)[-1].to_f
  end

  def log(options)
    options.user ||= ENV["USERNAME"]
    options.date ||= Date.today.to_s

    record = "#{options.project},#{options.user},#{options.date},#{options.hours}"

    write(record)
  end

  private

  def read(options)
    if options.user then
      read_for_user(options.user, options.project)
    else
      read_for_project(options.project)
    end
  end

  def read_for_user(user, project)
    read_for_project(project).grep(/,#{user},/)
  end

  def read_for_project(project)
    IO.readlines(@timelog_filename).grep(/^#{project},/)
  end

  def write(record)
    File.open(@timelog_filename, "a+") { |f| f.puts record }
  end
end
