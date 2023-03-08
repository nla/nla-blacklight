Flipper::UI.configure do |config|
  config.banner_text = "#{Rails.env} environment".titlecase
  if Rails.env.production?
    config.banner_class = "danger"
  end
end
