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

  test 'file deletion' do
    temp = Tempfile.new
    temp.write 'test data'
    temp.rewind
    @test_file.attachment = temp
    @test_file.save
    updated_test_file = SeFile.find @test_file.id
    assert File.exist? updated_test_file.attachment.path
    updated_test_file.destroy
    assert_not File.exist? @test_file.attachment.path
  end
end
