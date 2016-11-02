require 'test_helper'

class FilesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @test_file = SeFile.find_by name: 'test_file'
  end

  def create_random_file
    name = ('a'..'z').to_a.shuffle[0..30].join
    SeFile.create(name: name)
  end


  test 'get file works' do
    get file_url @test_file.name
    assert_response :success
    r = JSON.parse(response.body)
    assert_equal r["id"], @test_file.id
    assert_equal r["name"], @test_file.name
  end

  test 'get files works' do
    file1 = create_random_file
    file2 = create_random_file
    get files_url 
    assert_response :success
    r = JSON.parse response.body
    response_file_names = (r.map { |o| o["name"] }).sort
    db_file_names = (SeFile.all.to_a.map { |o| o.name }).sort
    assert response_file_names == db_file_names
  end

end
