require 'rspec'
<<<<<<< HEAD

=======
# class Object
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
class Object
  # This is necessary because the RAL has a 'should'
  # method.
  alias must should
  alias must_not should_not
end
