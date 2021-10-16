# frozen_string_literal: true

RSpec.describe LogFormatter do
  let(:log_array) { [['/about', 2], ['/index', 3]] }

  context 'when a title is provided' do
    let(:title) { 'Test title: ' }

    it('outputs the given log array with a title, separated by whitespace') do
      expect do
        described_class.format_output(log_array, title)
      end.to output("#{title}\n/about - 2 views\n/index - 3 views\n\n").to_stdout
    end
  end

  context 'when a title is not provided' do
    it('outputs the given log array') do
      expect do
        described_class.format_output(log_array)
      end.to output("/about - 2 views\n/index - 3 views\n\n").to_stdout
    end
  end

  context 'when the given log file has empty entries' do
    let(:log_array) { [['/about', 2], ['/home', ' '], ['/index', 3], [' ', 7]] }

    it('skips the empty entries') do
      expect do
        described_class.format_output(log_array)
      end.to output("/about - 2 views\n/index - 3 views\n\n").to_stdout
    end
  end

  context 'when a hash is provided' do
    let(:log_hash) { { '/about' => 2, '/index' => 3 } }

    it('successfully formats the output') do
      expect do
        described_class.format_output(log_hash)
      end.to output("/about - 2 views\n/index - 3 views\n\n").to_stdout
    end
  end
end
