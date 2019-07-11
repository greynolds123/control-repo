# @summary this class in the initial class to which all of configuration will be# sourced.
#
# A description of what this class does
#
# @example
#   include gitprod
  class gitprod {
  include gitprod::config
  include gitprod::remote
  include gitprod::users
  include gitprod::group
  include gitprod::eymal
}
