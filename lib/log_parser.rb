# frozen_string_literal: true

require_relative './log_formatter'
require_relative './exceptions/log_error'

# Reads logs and builds hashes for total and unique views, then calls LogFormatter to format the output
class LogParser
  def initialize(filepath)
    @filepath = filepath
    @page_views = Hash.new(0)
    @unique_page_views = Hash.new(0)
  end

  def parse_log
    @unique_page_viewers = Hash.new([])
    begin
      File.open(@filepath).each_line do |log_line|
        page, visitor = log_line.split(' ')
        if valid_page?(page) && valid_ip?(visitor)
          @page_views[page] += 1
          @unique_page_viewers[page] += [visitor] unless @unique_page_viewers[page].include? visitor
        end
      end
    rescue Errno::ENOENT, Errno::EISDIR
      raise LogError,
            "It looks like the file you supplied doesn't exist!\nMake sure it's pointing to the correct directory."
    end
    if @page_views.empty?
      raise LogError,
            "It looks like your log file is either empty or isn't formatted correctly.\nPlease make sure it's in the format '<webpage> <ip_address>'"
    end

    format_log
  end

  def format_log
    LogFormatter.format_output(@page_views.sort_by { |page, views| [-views, page] }, 'Total page views:')

    @unique_page_viewers.each do |page, viewers|
      @unique_page_views[page] += viewers.count
    end
    LogFormatter.format_output(@unique_page_views.sort_by { |page, views| [-views, page] }, 'Unique page views:')
  end

  private

  def valid_page?(page)
    return false if page.to_s.strip.empty?

    # This validation will need to change if the format of supplied webpages changes.
    # For now the logs only contain directories/subdirectories, but if this were to change then this validation would
    # need updating.
    return false unless page.to_s[0] == '/'

    true
  end

  def valid_ip?(ip_address)
    return false if ip_address.to_s.strip.empty?
    return false unless /([0-9]{3}\.){3}[0-9]/.match(ip_address)

    true
  end
end
