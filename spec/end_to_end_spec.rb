# frozen_string_literal: true

require_relative '../lib/log_parser'

RSpec.describe 'end to end' do
  it('builds ordered lists of pages by total views and by unique views') do
    expect do
      LogParser.new('./spec/test_logs/testlog1.log').parse_log
    end.to output("Total page views:\n/help_page/1 - 5 views\n/about/2 - 3 views\n/contact - 3 views\n/home - 3 views\n/index - 3 views\n/about - 2 views\n\nUnique page views:\n/help_page/1 - 5 views\n/home - 3 views\n/index - 3 views\n/about - 2 views\n/about/2 - 2 views\n/contact - 2 views\n\n").to_stdout
  end
end
