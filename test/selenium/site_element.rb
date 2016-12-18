require 'selenium-webdriver'
class SiteElement

	def initialize(url)
		@driver=Selenium::WebDriver.for :firefox
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
		@driver.find_element(:link_text, "Logout")
	end

	def upload_name_field
		@driver.find_element(:id, "upload_name")
	end

	def upload_file_field
		@driver.file_element(:id, "upload_file")
	end

	def upload_button()
		return @driver.find_element(:id, "upload_submit")
	end

	def file_row()
		# Use headerRow as placeholder for now
		return @driver.find_element(:id, "headerRow")
	end

	def close_browser()
		@driver.quit
	end
end
