require_relative 'site_element.rb'
	#define new browser
browser=SiteElement.new("http://54.218.119.184")

browser.upload_button.click

begin

	# Timeout = 5 sec
	wait = Selenium::WebDriver::Wait.new(:timeout => 5)

	puts "File upload test successful!" if wait.until {
    		/{"message":"Upload success:/.match(browser.page_source)
	}

rescue Selenium::WebDriver::Error::TimeOutError

	puts "File upload test failed!"

end

#puts isLogoutLinkDisplayed
browser.close_browser
