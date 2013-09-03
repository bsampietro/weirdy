# Weirdy

Weirdy is a Rails engine for exception tracking. It allows you to manage your application exceptions by the application 
itself. It provides a panel and an emal notification system.

## Installation:

``` ruby
## Gemfile for Rails
gem 'weirdy'
```

Copy and run the migrations

``` bash
$ rake weirdy:install:migrations
$ rake db:migrate
```

Mount it as any other engine on your application's config/routes.rb:

``` ruby
mount Weirdy::Engine => "/weirdy" # or any path
```

Declare basic configuration variables on any of your application's initialization file:

``` ruby
Weirdy::Config.configure do |config|
  config.mail_recipients = "youremail@server.com"
  config.auth = "admin/123" # http basic auth => user: admin, pass: 123
  config.app_name = "Your App Name"
end
```

Be sure to check out the Configuration section to change this options and for other configuration options.

### Assets

If the asset pipeline IS NOT enabled in your app, you will have to manually copy the necessary Javascript and stylesheet files.  
[Javascript] file should go in: "public/javascripts/weirdy/"  
[Stylesheet] file should go in: "public/stylesheets/weirdy/"

If the asset pipeline IS enabled you should have the jquery-rails gem in your Gemfile:

``` ruby
gem "jquery-rails"
```

### Rails 4

If you are using Rails 4, you should add the protected_attributes gem to your Gemfile:

``` ruby
gem "protected_attributes"
```

Now when you go to yourapp.com/weirdy, it should be working!


## Usage

Weirdy doesn't automatically log exceptions to avoid cluttering your application main code. 
There is a public method to log exceptions from anywhere in the code, and add extra information you want to keep.
The method to log exceptions is:

``` ruby
Weirdy.log_wexception(exception, data={})
```

where data is a hash with extra data you want to keep for each exception.

In your ApplicationController you can do something like this:

``` ruby
rescue_from Exception do |exception|
  Weirdy.log_exception(exception,
    {:session => session.inspect,
     :params => params,
     :url => request.url, 
     :method => request.method})
  raise exception
end
```

Weirdy will send emails for new exceptions and for reraised closed ones. It uses the same email sending configuration that your main app.

## Configuration

``` ruby
# Default values are on fields except when noted.

Weirdy::Config.mail_recipients = "batman@gothamcity.com"
# This field doesn't have a default value.

Weirdy::Config.auth = "admin/123"
# This field doesn't have a default value.

Weirdy::Config.use_main_app_controller = false

Weirdy::Config.app_directories = ["app/controllers", "app/helpers", "app/mailers", "app/models", "app/views"]

Weirdy::Config.mail_sender = "Weirdy <bugs@weirdyapp.com>"

Weirdy::Config.app_name = "My application"

Weirdy::Config.exceptions_per_page = 20

Weirdy::Config.shown_stack = 15

Weirdy::Config.mail_sending_proc = lambda { |email, wexception| email.deliver }
```

### Options

#### mail_recipients
*String or Array*
The recipients of the email, this field could be a single email or an array of emails.
If this field is empty, weirdy won't send any emails.

#### auth
*String or Proc*
Without an assigned value, it will allow to check weirdy without any auth. Be aware of this before deploying!  
If it is a string in the form of "user/password" it will use http basic auth with the given user/password  
If it is a proc, then if the proc returns true it allows access, if it return false it doesn't.  
The proc receives the active controller as a parameter, this way you can access session and cookies with
controller.session and controller.send(:cookies) (cookies is a private method)  
eg: Weirdy::Config.auth = lambda { |controller| User.find(controller.session[:user_id]).admin? }  
Checkout Weirdy::Config.use_main_app_controller property to be able to use the main application controller as the base 
controller for the engine, so you can use your own application authentication methods.  
eg: Weirdy::Config.auth = lambda { |controller| controller.current_user.admin? }  

#### use_main_app_controller
*Boolean*
It uses the main app controller as base for the engine, so you are able to access your application authentication methods
on the `auth` proc. Check out `auth` for an explanation.  

#### app_directories
*String or Array*
The directories (or files) that belongs to the application.  
This field is VERY important because it is used to find backtrace lines corresponding to your app, and based
on that, the exceptions are grouped not only by exception type, but also with the method from which they were raised.
(Weirdy does a simple comparison for each string on the exception stack, if the stack has any of these "app_directories" 
strings, it is marked as an application line in the stack.)  
Most application code in rails applications is inside these directories, that is why they are the defaults.
But if you have code on other directories like 'lib', then adding your app directory (Weirdy::Config.app_directories << "your_app_directory") could be useful.
Don't add just 'lib' because it is a very common directory name for libraries, and weirdy will not find the application lines correctly.
Add names that are ONLY in your application file paths and that are uniq.  
If you set this to nil, exceptions will be only grouped by type.

#### mail_sender
*String*
The sender of the email.

#### app_name
*String*
Your application name.

#### exceptions_per_page
*Number*
Number of exceptions shown before paging.

#### shown_stack
*Number*
Number of lines visible at first sight on the stack.

#### mail_sending_proc
*Proc*
The proc receives a mailer object and the wexception object(logged weirdy exception), is call to send the email.
This field default is to send the email on the request by just calling deliver on the email.
The wexception is also passed because there is some trouble with serializing mailer objects, so if you use a queing library 
that can't serialize the email object, the wexception is also passed and you can call: Weirdy.notify_exception(wexception)
to send the email.  
Check the delayed job example below.  

To avoid repeating Weirdy::Config, you can use this block as it was shown above:

``` ruby
Weirdy::Config.configure do |config|
  config.mail_recipients = "bsampietro@gmail.com"
  config.auth = "admin/bruno1"
  config.app_directories << "your_app_directory"
  config.app_name = "your app"
  #...
end
```

## Delayed Job example

Here is an example on how to send mails with delayed job:

``` ruby
Weirdy::Config.mail_sending_proc = lambda { |email, wexception| Delayed::Job.enqueue NotifierJob.new(wexception) }

# and NotifierJob defined like this:

class NotifierJob < Struct.new(:wexception)
  def perform
    Weirdy.notify_exception(wexception)
  end
end

# Weirdy.notify_exception(wexception) is the public method to send emails based on a weirdy exception (wexception)
```

## Compatibility

Rails: It was tested with Rails 3.2 and 4.0. It should work with >= 3.0. Let me know of any issues.  
DB's: It was tested on: MySql, Postgres, and SQLite  



And that is it! Please report [issues] on GitHub.



[issues]: https://github.com/bsampietro/weirdy/issues
[javascript]: https://raw.github.com/bsampietro/weirdy/master/util_files/application.js
[stylesheet]: https://raw.github.com/bsampietro/weirdy/master/util_files/application.css

