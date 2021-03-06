require 'test_helper'

class FileNodeFilesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @test_file = SeFile.find_by name: 'test_file'
  end

  def create_random_file
    name = ('a'..'z').to_a.sample(31).join
    SeFile.create name: name, attachment: generate_temporary_file
  end

  test 'get file works for file_node environment' do
    Rails.env = 'file_node'
    get file_node_file_url @test_file.name
    assert_response :success
    r = JSON.parse(response.body)
    assert_equal r['id'], @test_file.id
    assert_equal r['name'], @test_file.name
    Rails.env = 'test'
  end

  test 'get file fails for master environment' do
    Rails.env = 'master'
    # This exception is raised if the route returns nothing
    assert_raises(
      ActionController::UnknownFormat
    ) { get file_node_file_url @test_file.name }
    Rails.env = 'test'
  end

  test 'get files works for file_node environment' do
    Rails.env = 'file_node'
    create_random_file
    create_random_file
    get file_node_files_url
    assert_response :success
    r = JSON.parse response.body
    response_file_names = (r.map { |o| o['name'] }).sort
    db_file_names = SeFile.all.to_a.map(&:name).sort
    assert response_file_names == db_file_names
    Rails.env = 'test'
  end

  test 'get files fails for master environment' do
    Rails.env = 'master'
    create_random_file
    create_random_file
    assert_raises(
      ActionController::UnknownFormat
    ) { get file_node_files_url }
    Rails.env = 'test'
  end

  test 'file downloads successfully for file_node environment' do
    Rails.env = 'file_node'
    file = create_random_file
    data = File.open(file.attachment.path).read
    get file_node_file_download_url file.name
    assert data == response.body
    Rails.env = 'test'
  end

  test 'file downloads successfully for master environment' do
    Rails.env = 'master'
    file = create_random_file
    assert_raises(
      ActionController::UnknownFormat
    ) { get file_node_file_download_url file.name }
    Rails.env = 'test'
  end

  test 'missing file download returns 400' do
    Rails.env = 'file_node'
    get file_node_file_download_url 'whatever_file'
    assert_response 400
    Rails.env = 'test'
  end

  test 'post file works' do
    post file_node_upload_url,
         params: {
           se_file: {name: 'hi', attachment: fixture_file_upload('files/test.txt')}
         }
    assert JSON.parse(response.body)["message"] == "Upload success: File hi successfully uploaded!"
  end

  test 'post file shows error when paperclip throws error' do
    post file_node_upload_url,
         params: {
           se_file: {
             name: 'hi', attachment: fixture_file_upload('files/test.py')
           }
         }
    assert_response 400
  end

  test 'post empty filename fails' do
    post file_node_upload_url,
         params: {
           se_file: {name: '', attachment: fixture_file_upload('files/test.txt')}
         }
  end

  test 'post missing file returns 400' do
    params = {
      se_file: {
        name: 'testFile.txt'
      }
    }
    post file_node_upload_url, params: params
    assert_response 400
  end

  test 'post empty file returns 400' do
    params = {
      se_file: {
        name: 'testFile.txt',
        attachment: fixture_file_upload('files/empty.txt')
      }
    }
    post file_node_upload_url, params: params
    assert_response 400
  end

  test 'delete file works' do
    file = create_random_file
    delete file_node_file_url file.name
    assert_response 200
    assert_not SeFile.exists?(file.id)
  end

  test 'delete non-existant file' do
    filename = 'thisisnotarealfile'
    delete file_node_file_url filename
    assert_response 400
    assert_not SeFile.exists?(name: filename)
  end
end
