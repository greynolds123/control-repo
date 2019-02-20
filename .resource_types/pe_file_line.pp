# This file was automatically generated on 2017-02-13 04:10:30 -0800.
# Use the 'puppet generate types' command to regenerate this file.

# Ensures that a given line is contained within a file.  The implementation
# matches the full line, including whitespace at the beginning and end.  If
# the line is not contained in the given file, Puppet will add the line to
# ensure the desired state.  Multiple resources may be declared to manage
# multiple lines in the same file.
# 
# Example:
# 
#     pe_file_line { 'sudo_rule':
#       path => '/etc/sudoers',
#       line => '%sudo ALL=(ALL) ALL',
#     }
#     pe_file_line { 'sudo_rule_nopw':
#       path => '/etc/sudoers',
#       line => '%sudonopw ALL=(ALL) NOPASSWD: ALL',
#     }
# 
# In this example, Puppet will ensure both of the specified lines are
# contained in the file /etc/sudoers.
# 
# **Autorequires:** If Puppet is managing the file that will contain the line
# being managed, the pe_file_line resource will autorequire that file.
Puppet::Resource::ResourceType3.new(
  'pe_file_line',
  [
    # The basic property that the resource should be in.
    # 
    # Valid values are `present`, `absent`.
    Puppet::Resource::Param(Enum['present', 'absent'], 'ensure')
  ],
  [
    # An arbitrary name used as the identity of the resource.
    Puppet::Resource::Param(Any, 'name', true),

    # An optional regular expression to run against existing lines in the file;\nif a match is found, we replace that line rather than adding a new line.
    Puppet::Resource::Param(Any, 'match'),

    # An optional value to determine if match can change multiple lines.
    # 
    # Valid values are `true`, `false`.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false']], 'multiple'),

    # An optional value used to specify the line after which we will add any new lines. (Existing lines are added in place)
    Puppet::Resource::Param(Any, 'after'),

    # The line to be appended to the file located by the path parameter.
    Puppet::Resource::Param(Any, 'line'),

    # The file Puppet will ensure contains the line specified by the line parameter.
    Puppet::Resource::Param(Any, 'path'),

    # The specific backend to use for this `pe_file_line`
    # resource. You will seldom need to specify this --- Puppet will usually
    # discover the appropriate provider for your platform.Available providers are:
    # 
    # ruby
    # :
    Puppet::Resource::Param(Any, 'provider')
  ],
  {
    /(.*)/ => ['name']
  },
  true,
  false)
