require 'selenium-webdriver'
class SiteElement

	def initialize(url)
		@driver=Selenium::WebDriver.for :chrome
		@driver.manage.window.maximize
		@driver.navigate.to url
	end

	def login_username()
		return @driver.find_element(:id, 'login_login_username')
	end

	def login_password()
		return @driver.find_element(:id, 'login_login_password')
	end

	def submit_button()
		return @driver.find_element(:id, "login_submit")
	end

	def logout_link()
		@driver.find_element(:link_text, 'Logout')
	end

	def close_browser()
		@driver.quit
	end
end
