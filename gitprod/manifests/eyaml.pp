# This module installs eymal per module request.
#
#
  class gitprod::eyaml {
  package  { 'eyaml':
  ensure   => 'installed',
  provider => 'gem',
  }
  }
