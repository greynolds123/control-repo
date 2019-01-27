<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
=======
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
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
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
end
