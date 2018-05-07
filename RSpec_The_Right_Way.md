# Rspec the Right Way

## The Basics

 - Install Rails
 - Create a new Rails Application
 - Add RSpec to your Application

Install Rails
```
gem install rails
```

Generate new Rails Product
```
rails new CommentsDashboard
cd CommentsDashboard
```

Verify it's working
```
rails server
```

View it at localhost:3000; should see rails welcome screen.

Ctrl + c to quit server.

Open Gemfile, and add rspec for when we are in 'test' and 'development' mode:
```
group :test, :development do
    gem 'rspec-rails', '~>2.0'
end
```

Install gems
```
bundle install
```

Generate Rspec
```
rails generate rspec
```

## RSpec Alone
  - Create a basic RSpec example to test your application
  - Run specs on the command line
  - Understand the describe and it methods
  - Understand the red/green cycle of the development
  - Implement the first feature of the application
  - Create a Wordpress client and give it a URL

