# frozen_string_literal: true

require 'spec_helper'
require_relative '../lib/exceptions/log_error'

RSpec.describe LogParser do
  let(:filepath) { 'spec/test_logs/testlog1.log' }

  subject { LogParser.new(filepath) }

  context 'when given a valid log file' do
    it 'opens the file once' do
      allow(File).to receive(:open).and_call_original
      subject.parse_log

      expect(File).to have_received(:open).once
    end

    it 'builds a hash of total page views' do
      subject.parse_log

      expect(subject.instance_variable_get(:@page_views))
        .to eq({ '/about' => 2, '/about/2' => 3, '/contact' => 3, '/help_page/1' => 5, '/home' => 3, '/index' => 3 })
    end

    it 'builds a hash of unique page views' do
      subject.parse_log

      expect(subject.instance_variable_get(:@unique_page_views))
        .to eq({ '/about' => 2, '/about/2' => 2, '/contact' => 2, '/help_page/1' => 5, '/home' => 3, '/index' => 3 })
    end

    it 'calls for the logs to be formatted' do
      allow(subject).to receive(:format_log).and_call_original
      allow(LogFormatter).to receive(:format_output)
      subject.parse_log

      expect(subject).to have_received(:format_log).once
      expect(LogFormatter).to have_received(:format_output).twice
    end

    context 'when passing the logs to the LogFormatter' do
      before(:each) do
        allow(LogFormatter).to receive(:format_output)
          .with([['/help_page/1', 5], ['/about/2', 3], ['/contact', 3], ['/home', 3], ['/index', 3],
                 ['/about', 2]], 'Total page views:')
        allow(LogFormatter).to receive(:format_output)
          .with([['/help_page/1', 5], ['/home', 3], ['/index', 3], ['/about', 2], ['/about/2', 2],
                 ['/contact', 2]], 'Unique page views:')
      end

      it 'orders the logs by total view count' do
        subject.parse_log

        expect(LogFormatter).to have_received(:format_output)
          .with([['/help_page/1', 5], ['/about/2', 3], ['/contact', 3], ['/home', 3], ['/index', 3],
                 ['/about', 2]], 'Total page views:')
          .once
      end

      it 'orders the logs by unique view count' do
        subject.parse_log

        expect(LogFormatter).to have_received(:format_output)
          .with([['/help_page/1', 5], ['/home', 3], ['/index', 3], ['/about', 2], ['/about/2', 2],
                 ['/contact', 2]], 'Unique page views:')
          .once
      end
    end
  end

  context 'when the log file contains incomplete data' do
    let(:filepath) { 'spec/test_logs/testlog2.log' }

    it "ignores log entries that don't have a corresponding IP address" do
      subject.parse_log

      expect(subject.instance_variable_get(:@page_views))
        .to eq({ '/about' => 2, '/about/2' => 3, '/contact' => 3, '/help_page/1' => 5, '/home' => 3, '/index' => 3 })

      expect(subject.instance_variable_get(:@unique_page_views))
        .to eq({ '/about' => 2, '/about/2' => 2, '/contact' => 2, '/help_page/1' => 5, '/home' => 3, '/index' => 3 })
    end
  end

  context 'when the log file has excess whitespace' do
    let(:filepath) { 'spec/test_logs/testlog3.log' }

    it 'ignores log entries made only of whitespace' do
      subject.parse_log

      expect(subject.instance_variable_get(:@page_views))
        .to eq({ '/about' => 2, '/about/2' => 3, '/contact' => 3, '/help_page/1' => 5, '/home' => 3, '/index' => 3 })

      expect(subject.instance_variable_get(:@unique_page_views))
        .to eq({ '/about' => 2, '/about/2' => 2, '/contact' => 2, '/help_page/1' => 5, '/home' => 3, '/index' => 3 })
    end
  end

  context 'when the log file is gibberish' do
    let(:filepath) { 'spec/test_logs/gibberish.log' }

    it 'gives an error message about the format of the file' do
      expect do
        subject.parse_log
      end.to raise_error(LogError,
                         "It looks like your log file is either empty or isn't formatted correctly.\nPlease make sure it's in the format '<webpage> <ip_address>'")
    end
  end

  context 'when given a log file that does not exist' do
    let(:filepath) { 'spec/test_logs/nonexistent.log' }

    it 'handles the file not existing' do
      expect do
        subject.parse_log
      end.to raise_error(LogError,
                         "It looks like the file you supplied doesn't exist!\nMake sure it's pointing to the correct directory.")
    end
  end

  context 'when given a directory' do
    let(:filepath) { 'spec/test_logs' }

    it 'handles the directory as a missing file' do
      expect do
        subject.parse_log
      end.to raise_error(LogError,
                         "It looks like the file you supplied doesn't exist!\nMake sure it's pointing to the correct directory.")
    end
  end
end
