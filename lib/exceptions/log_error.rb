# frozen_string_literal: true

# Custom error to handle issue with the log file, to prevent other potential errors being caught unexpectedly.
class LogError < StandardError
  def initialize(message = 'There seems to be an issue with your log file')
    super(message)
  end
end
