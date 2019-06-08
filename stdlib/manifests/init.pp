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
>>>>>>> f661b3a03526f113b1823084ffd4808cf261cf70
}
