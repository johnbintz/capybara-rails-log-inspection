# Capybara::RailsLogInspection

Errors not bubbling up from your Rails app to Cucumber? Use this!

``` ruby
# features/support/env.rb

require 'capybara/rails-log-inspection/cucumber'
```

Exceptions and Rails logging (`Rails.logger.info`) will pass through to Cucumber.
No more watching logs or any other nonsense!

## Installation

Add this line to your application's Gemfile:

    gem 'capybara-rails-log-inspection'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install capybara-rails-log-inspection

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
