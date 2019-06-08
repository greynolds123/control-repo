require 'rspec'
<<<<<<< HEAD

=======
# class Object
>>>>>>> f661b3a03526f113b1823084ffd4808cf261cf70
class Object
  # This is necessary because the RAL has a 'should'
  # method.
  alias must should
  alias must_not should_not
end
