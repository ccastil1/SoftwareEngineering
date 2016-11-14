require 'test_helper'

class FilesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @test_file = SeFile.find_by name: 'test_file'
  end

  def create_random_file
    name = ('a'..'z').to_a.sample(31).join
    SeFile.create name: name, attachment: generate_temporary_file
  end

  test 'post file works' do
    post file_upload_url,
         params: {
           se_file: {name: 'hi', attachment: fixture_file_upload('files/test.txt')}
         }
  end

  test 'post missing file returns 400' do
    params = {
      se_file: {
        name: 'testFile.txt'
      }
    }
    post file_upload_url, params: params
    assert_response 400
  end

  test 'post empty file returns 400' do
    params = {
      se_file: {
        name: 'testFile.txt',
        attachment: fixture_file_upload('files/empty.txt')
      }
    }
    post file_upload_url, params: params
    assert_response 400
  end

  test 'get file works' do
    get file_url @test_file.name
    assert_response :success
    r = JSON.parse(response.body)
    assert_equal r['id'], @test_file.id
    assert_equal r['name'], @test_file.name
  end

  test 'get missing file returns 400' do
    get file_url 'missing_file'
    assert_response 400
  end

  test 'get files works' do
    create_random_file
    create_random_file
    get files_url
    assert_response :success
    r = JSON.parse response.body
    response_file_names = (r.map { |o| o['name'] }).sort
    db_file_names = SeFile.all.to_a.map(&:name).sort
    assert response_file_names == db_file_names
  end

  test 'file downloads successfully' do
    file = create_random_file
    data = File.open(file.attachment.path).read
    get file_download_url file.name
    assert data == response.body
  end

  test 'missing file download returns 400' do
    get file_download_url 'whatever_file'
    assert_response 400
  end

  test 'delete file works' do
    file = create_random_file
    delete file_url file.name
    assert_response 200
    assert_not SeFile.exists?(file.id)
  end

  test 'delete non-existant file' do
    filename = 'thisisnotarealfile'
    delete file_url filename
    assert_response 400
    assert_not SeFile.exists?(name: filename)
  end
end
