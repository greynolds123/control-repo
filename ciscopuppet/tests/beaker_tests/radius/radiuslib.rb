###############################################################################
# Copyright (c) 2014-2015 Cisco and/or its affiliates.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
###############################################################################
# Radius Global Utility Library:
# ---------------------
# radiuslib.rb
#
# This is the utility library for the Radius provider Beaker test cases
# that contains the common methods used across the Radius Server testsuite's
# cases. The library is implemented as a module with related methods and
# constants defined inside it for use as a namespace. All of the methods are
# defined as module methods.
#
# Every Beaker Radius test case that runs an instance of Beaker::TestCase
# requires RadiusSettingLib module.
#
# The module has a single set of methods:
# A. Methods to create manifests for radius Puppet provider test cases.
###############################################################################

# Require UtilityLib.rb path.
require File.expand_path('../../lib/utilitylib.rb', __FILE__)

# A library to assist testing radius resource
module RadiusLib
  # A. Methods to create manifests for radius Puppet provider test cases.

  # Method to create a manifest for radius true
  # @param none [None] No input parameters exist.
  # @result none [None] Returns no object.
  def self.create_radius_manifest_true
    manifest_str = "cat <<EOF >#{PUPPETMASTER_MANIFESTPATH}
node default {
  radius { 'default':
    enable => 'true',
  }
}
EOF"
    manifest_str
  end

  # Method to create a manifest for radius false
  # @param none [None] No input parameters exist.
  # @result none [None] Returns no object.
  def self.create_radius_manifest_false
    manifest_str = "cat <<EOF >#{PUPPETMASTER_MANIFESTPATH}
node default {
  radius { 'default':
    enable => 'false',
  }
}
EOF"
    manifest_str
  end
end
