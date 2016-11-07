ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def generate_temporary_file(data = nil)
    file = Tempfile.new
    data = ('a'..'z').to_a.sample(17).join if data.nil?
    file.write data
    file.rewind
    file
  end
end
