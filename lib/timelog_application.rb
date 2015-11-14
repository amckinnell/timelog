class TimelogApplication
  def initialize(timelog_filename)
    @timelog_filename = timelog_filename
  end

  def report(options)
    records = IO.readlines(@timelog_filename)
    records = records.grep(/^#{options.project},/)
    records = records.grep(/,#{options.user},/) if options.user
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

  def log(options)
    options.user ||= ENV["USERNAME"]
    options.date ||= Date.today.to_s
    File.open @timelog_filename, "a+" do |f|
      f.puts "#{options.project},#{options.user},#{options.date},#{options.hours}"
    end
  end
end
