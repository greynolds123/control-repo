# automatically load any shared examples or contexts
<<<<<<< HEAD
Dir["./spec/support/**/*.rb"].sort.each { |f| require f }

require 'simplecov'
=======
Dir['./spec/support/**/*.rb'].sort.each { |f| require f }

require 'simplecov'
require 'shared_functions'
>>>>>>> f661b3a03526f113b1823084ffd4808cf261cf70
SimpleCov.start do
  add_filter '/spec/'
  add_filter '/.bundle/'
end
