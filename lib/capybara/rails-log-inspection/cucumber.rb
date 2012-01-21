require 'capybara/rails-log-inspection'

World(Capybara::RailsLogInspection)

Before do
  reset_logs
end

AfterStep do
  output_logs
end

After do
  output_logs
end
