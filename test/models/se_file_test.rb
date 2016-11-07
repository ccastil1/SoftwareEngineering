require 'test_helper'

class SeFileTest < ActiveSupport::TestCase
  def setup
    @test_file = SeFile.find_by name: 'test_file'
  end

  def generate_temporary_file(data = nil)
    file = Tempfile.new
    data = ('a'..'z').to_a.sample(17).join if data.nil?
    file.write data
    file.rewind
    file
  end

  test 'filenames must be unique' do
    assert_raise(ActiveRecord::RecordInvalid) { @test_file.dup.save! }
  end

  test 'file creation' do
    data = 'random stuff'
    temp = generate_temporary_file data
    @test_file.attachment = temp
    @test_file.save
    updated_file = File.open SeFile.find(@test_file.id).attachment.path
    assert updated_file.read == data
  end

  test 'file deletion' do
    temp = generate_temporary_file
    @test_file.attachment = temp
    @test_file.save
    updated_test_file = SeFile.find @test_file.id
    assert File.exist? updated_test_file.attachment.path
    updated_test_file.destroy
    assert_not File.exist? @test_file.attachment.path
  end
end
