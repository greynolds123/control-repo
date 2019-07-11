# Class: stdlib
#
# This module manages stdlib. Most of stdlib's features are automatically
# loaded by Puppet, but this class should be declared in order to use the
# standardized run stages.
#
# Parameters: none
#
# Actions:
#
#   Declares all other classes in the stdlib module. Currently, this consists
#   of stdlib::stages.
#
# Requires: nothing
#
class stdlib {
<<<<<<< HEAD
  include stdlib::stages
=======
  include ::stdlib::stages
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
}
