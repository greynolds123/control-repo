<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
=======
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
require 'rspec'

class Object
  # This is necessary because the RAL has a 'should'
  # method.
<<<<<<< HEAD
  alias :must :should
  alias :must_not :should_not
=======
  alias must should
  alias must_not should_not
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
end
