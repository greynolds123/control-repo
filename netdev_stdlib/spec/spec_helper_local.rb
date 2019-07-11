# automatically load any shared examples or contexts
<<<<<<< HEAD
Dir["./spec/support/**/*.rb"].sort.each { |f| require f }

require 'simplecov'
=======
Dir['./spec/support/**/*.rb'].sort.each { |f| require f }

require 'simplecov'
require 'shared_functions'
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
SimpleCov.start do
  add_filter '/spec/'
  add_filter '/.bundle/'
end
