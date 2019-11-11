require 'rspec'
<<<<<<< HEAD

=======
# class Object
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
class Object
  # This is necessary because the RAL has a 'should'
  # method.
  alias must should
  alias must_not should_not
end
