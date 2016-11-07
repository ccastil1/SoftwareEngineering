require 'test_helper'

class SeFileTest < ActiveSupport::TestCase
  def setup
    @test_file = SeFile.find_by name: 'test_file'
  end

  test 'filenames must be unique' do
    assert_raise(ActiveRecord::RecordInvalid) { @test_file.dup.save! }
  end

  test 'file creation' do
    data = 'random stuff'
    temp = Tempfile.new
    temp.write data
    temp.rewind
    @test_file.attachment = temp
    @test_file.save
    updated_file = File.open SeFile.find(@test_file.id).attachment.path
    assert updated_file.read == data
  end
end
