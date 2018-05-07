
# The Basics

## Rails Setup

 - Install Rails
 - Create a new Rails Application
 - Add RSpec to your Application

Install Rails (install ruby first)
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

### Keywords
**implementation**

Code that runs when you deploy your application to rpoduction. The code that actually does stuff.

Example:

Code for a user model that stores the name and passwords of people who use your library.

**example & specs**

Code that describes what your implementation code should do, and runs against it to verify that it does. 

An example is a single statement: "it should parse XML."

A spec is a group of examples.

Example:

RSpec code that describes the kind of valid email addresses that should be accepted by a user model: "bacon" is not an email address and should be rejected by implementation code.

