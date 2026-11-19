module ChromeReset
  private

  # Clear session and local storage before Capybara navigates to about:blank.
  def uniform_storage_clear?
    false
  end

  def execute_cdp(command, params = {})
    # Chrome 158 rejects the wildcard origin used by Capybara 3.40.
    return super("Network.clearBrowserCookies") if command == "Storage.clearDataForOrigin" && params[:origin] == "*"

    super
  end
end

Capybara::Selenium::Driver::ChromeDriver.prepend(ChromeReset)
