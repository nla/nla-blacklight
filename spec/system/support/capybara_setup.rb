Capybara.server = :puma
Capybara.default_max_wait_time = 2
Capybara.default_normalize_ws = true
Capybara.save_path = ENV.fetch("CAPYBARA_ARTIFACTS", "./tmp/capybara")

Capybara.register_driver(:selenium_chrome) do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument("--headless") if ENV.fetch("HEADLESS", "false") == "true"
  options.add_argument("--no-sandbox")
  options.add_argument("--disable-gpu")
  options.add_argument("--disable-dev-shm-usage")
  options.add_argument("--window-size=1200,800")

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

Capybara.default_driver = Capybara.javascript_driver = :selenium_chrome

Capybara.singleton_class.prepend(Module.new do
  attr_accessor :last_used_session

  def using_session(name, &block)
    self.last_used_session = name
    super
  ensure
    self.last_used_session = nil
  end
end)
