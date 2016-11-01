require 'test_helper'

class FilesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @test_file = SeFile.new name: "test file"
  end

  test 'get file works' do
    @test_file.save
    get file_url @test_file
    assert_response :success
    r = JSON.parse(response.body)
    assert_equal r["id"], @test_file.id
    assert_equal r["name"], @test_file.name
  end
end
