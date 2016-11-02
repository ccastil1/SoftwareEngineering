require 'test_helper'

class SeFileTest < ActiveSupport::TestCase
  def setup
    @test_file = SeFile.find_by name: 'test_file'
  end

  test 'filenames must be unique' do
    assert_raise(ActiveRecord::RecordInvalid) { @test_file.dup.save! }
  end
end
