require_relative 'site_element.rb'
	#define new browser
browser=SiteElement.new("http://54.218.119.184")

	#wait until logout link displays, timeout in 10 seconds
wait = Selenium::WebDriver::Wait.new(:timeout => 10)
wait.until {browser.delete_link }

browser.close_browser
