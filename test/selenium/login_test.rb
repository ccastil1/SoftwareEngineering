require_relative 'site_element.rb'
	#define new browser
browser=SiteElement.new("URL_HERE")

	#input user name
browser.login_username.send_keys('Student1')

	#input password
browser.login_password.send_keys('Testing1')

	#click on submit button
browser.submit_button.click

	#wait until logout link displays, timeout in 10 seconds
wait = Selenium::WebDriver::Wait.new(:timeout => 10)
wait.until {browser.logout_link }

	#if logout link is displayed
isLogoutLinkDisplayed=browser.logout_link.displayed?

puts isLogoutLinkDisplayed
browser.close_browser
