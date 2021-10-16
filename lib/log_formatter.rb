# frozen_string_literal: true

# Formats output for provided log enumerables.
# I wanted to keep this class relatively agnostic of validations so that it would be usable for other types of logs.
class LogFormatter
  def self.format_output(log, title = '')
    puts title.to_s unless title.empty?

    log.each do |page, views|
      next if page.to_s.strip.empty? || views.to_s.strip.empty?

      puts "#{page} - #{views} views"
    end
    puts ''
  end
end
