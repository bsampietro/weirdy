Weirdy::Config.configure do |config|
  config.mail_recipients = ["bsampietro@gmail.com", "sonnyonrails@gmail.com"]
  config.app_name = "Dummy app"
  config.exceptions_per_page = 5
  config.mail_sending_proc = lambda { |email, wexception| Delayed::Job.enqueue NotifierJob.new(wexception) }
end
