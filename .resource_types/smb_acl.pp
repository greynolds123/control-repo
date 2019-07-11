# This file was automatically generated on 2019-06-08 13:59:54 -0700.
# Use the 'puppet generate types' command to regenerate this file.

# Ensures that a set of ACL permissions are applied to a given file
# or directory.
# 
#  Example:
# 
#      smb_acl { '/var/www/html':
#        action      => exact,
#        permission  => [
#          'user::rwx',
#          'group::r-x',
#          'mask::rwx',
#          'other::r--',
#          'default:user::rwx',
#          'default:user:www-data:r-x',
#          'default:group::r-x',
#          'default:mask::rwx',
#          'default:other::r--',
#        ],
#        provider    => posixacl,
#        recursive   => true,
#      }
# 
#  In this example, Puppet will ensure that the user and group
#  permissions are set recursively on /var/www/html as well as add
#  default permissions that will apply to new directories and files
#  created under /var/www/html
# 
#  Setting an ACL can change a file's mode bits, so if the file is
#  managed by a File resource, that resource needs to set the mode
#  bits according to what the calculated mode bits will be, for
#  example, the File resource for the ACL above should be:
# 
#      file { '/var/www/html':
#             mode => 754,
#           }
Puppet::Resource::ResourceType3.new(
  'smb_acl',
  [
    # ACL permission(s).
    Puppet::Resource::Param(Any, 'permission')
  ],
  [
    # What do we do with this list of ACLs? Options are set, unset, exact, and purge
    # 
    # Valid values are `set`, `unset`, `exact`, `purge`.
    Puppet::Resource::Param(Enum['set', 'unset', 'exact', 'purge'], 'action'),

    # The file or directory to which the ACL applies.
    Puppet::Resource::Param(Any, 'path', true),

    # Apply ACLs recursively.
    # 
    # Valid values are `true`, `false`.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false']], 'recursive'),

    # The specific backend to use for this `smb_acl`
    # resource. You will seldom need to specify this --- Puppet will usually
    # discover the appropriate provider for your platform.Available providers are:
    # 
    # genericacl
    # : 
    # 
    # posixacl
    # : Provide posix 1e acl functions using posix getfacl/setfacl commands
    # 
    #   * Required binaries: `/usr/bin/getfacl`, `/usr/bin/setfacl`.
    #   * Default for `operatingsystem` == `debian, ubuntu, redhat, centos, fedora`.
    Puppet::Resource::Param(Any, 'provider')
  ],
  {
    /(?m-ix:(.*))/ => ['path']
  },
  true,
  false)
