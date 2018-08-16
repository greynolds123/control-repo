Puppet::Type.newtype(:file_line) do
<<<<<<< HEAD

  desc <<-EOT
=======
  desc <<-DOC
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
    Ensures that a given line is contained within a file.  The implementation
    matches the full line, including whitespace at the beginning and end.  If
    the line is not contained in the given file, Puppet will append the line to
    the end of the file to ensure the desired state.  Multiple resources may
    be declared to manage multiple lines in the same file.

    Example:

        file_line { 'sudo_rule':
          path => '/etc/sudoers',
          line => '%sudo ALL=(ALL) ALL',
        }

        file_line { 'sudo_rule_nopw':
          path => '/etc/sudoers',
          line => '%sudonopw ALL=(ALL) NOPASSWD: ALL',
        }

    In this example, Puppet will ensure both of the specified lines are
    contained in the file /etc/sudoers.

    Match Example:

        file_line { 'bashrc_proxy':
          ensure => present,
          path   => '/etc/bashrc',
          line   => 'export HTTP_PROXY=http://squid.puppetlabs.vm:3128',
          match  => '^export\ HTTP_PROXY\=',
        }

    In this code example match will look for a line beginning with export
    followed by HTTP_PROXY and replace it with the value in line.

<<<<<<< HEAD
    Match Example With `ensure => absent`:
=======
    Examples With `ensure => absent`:

    This type has two behaviors when `ensure => absent` is set.

    One possibility is to set `match => ...` and `match_for_absence => true`,
    as in the following example:
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870

        file_line { 'bashrc_proxy':
          ensure            => absent,
          path              => '/etc/bashrc',
<<<<<<< HEAD
          line              => 'export HTTP_PROXY=http://squid.puppetlabs.vm:3128',
=======
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
          match             => '^export\ HTTP_PROXY\=',
          match_for_absence => true,
        }

    In this code example match will look for a line beginning with export
    followed by HTTP_PROXY and delete it.  If multiple lines match, an
    error will be raised unless the `multiple => true` parameter is set.

<<<<<<< HEAD
    **Autorequires:** If Puppet is managing the file that will contain the line
    being managed, the file_line resource will autorequire that file.
  EOT
=======
    Note that the `line => ...` parameter would be accepted BUT IGNORED in
    the above example.

    The second way of using `ensure => absent` is to specify a `line => ...`,
    and no match:

        file_line { 'bashrc_proxy':
          ensure => absent,
          path   => '/etc/bashrc',
          line   => 'export HTTP_PROXY=http://squid.puppetlabs.vm:3128',
        }

    Note that when ensuring lines are absent this way, the default behavior
    this time is to always remove all lines matching, and this behavior
    can't be disabled.

    Encoding example:

        file_line { "XScreenSaver":
          ensure   => present,
          path     => '/root/XScreenSaver',
          line     => "*lock: 10:00:00",
          match    => '^*lock:',
          encoding => "iso-8859-1",
        }

    Files with special characters that are not valid UTF-8 will give the
    error message "invalid byte sequence in UTF-8".  In this case, determine
    the correct file encoding and specify the correct encoding using the
    encoding attribute, the value of which needs to be a valid Ruby character
    encoding.

    **Autorequires:** If Puppet is managing the file that will contain the line
    being managed, the file_line resource will autorequire that file.
  DOC
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870

  ensurable do
    defaultvalues
    defaultto :present
  end

  newparam(:name, :namevar => true) do
    desc 'An arbitrary name used as the identity of the resource.'
  end

  newparam(:match) do
<<<<<<< HEAD
    desc 'An optional ruby regular expression to run against existing lines in the file.' +
         ' If a match is found, we replace that line rather than adding a new line.' +
         ' A regex comparison is performed against the line value and if it does not' +
=======
    desc 'An optional ruby regular expression to run against existing lines in the file.' \
         ' If a match is found, we replace that line rather than adding a new line.' \
         ' A regex comparison is performed against the line value and if it does not' \
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
         ' match an exception will be raised.'
  end

  newparam(:match_for_absence) do
<<<<<<< HEAD
    desc 'An optional value to determine if match should be applied when ensure => absent.' +
         ' If set to true and match is set, the line that matches match will be deleted.' +
         ' If set to false (the default), match is ignored when ensure => absent.' +
=======
    desc 'An optional value to determine if match should be applied when ensure => absent.' \
         ' If set to true and match is set, the line that matches match will be deleted.' \
         ' If set to false (the default), match is ignored when ensure => absent.' \
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
         ' When `ensure => present`, match_for_absence is ignored.'
    newvalues(true, false)
    defaultto false
  end

  newparam(:multiple) do
<<<<<<< HEAD
    desc 'An optional value to determine if match can change multiple lines.' +
=======
    desc 'An optional value to determine if match can change multiple lines.' \
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
         ' If set to false, an exception will be raised if more than one line matches'
    newvalues(true, false)
  end

  newparam(:after) do
<<<<<<< HEAD
    desc 'An optional value used to specify the line after which we will add any new lines. (Existing lines are added in place)' +
         ' This is also takes a regex.'
  end

  newparam(:line) do
    desc 'The line to be appended to the file or used to replace matches found by the match attribute.'
=======
    desc 'An optional value used to specify the line after which we will add any new lines. (Existing lines are added in place)' \
         ' This is also takes a regex.'
  end

  # The line property never changes; the type only ever performs a create() or
  # destroy(). line is a property in order to allow it to correctly handle
  # Sensitive type values. Because it is a property which will never change,
  # it should never be considered out of sync.
  newproperty(:line) do
    desc 'The line to be appended to the file or used to replace matches found by the match attribute.'

    def retrieve
      @resource[:line]
    end
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
  end

  newparam(:path) do
    desc 'The file Puppet will ensure contains the line specified by the line parameter.'
    validate do |value|
      unless Puppet::Util.absolute_path?(value)
        raise Puppet::Error, "File paths must be fully qualified, not '#{value}'"
      end
    end
  end

  newparam(:replace) do
    desc 'If true, replace line that matches. If false, do not write line if a match is found'
    newvalues(true, false)
    defaultto true
  end

<<<<<<< HEAD
=======
  newparam(:replace_all_matches_not_matching_line) do
    desc 'Configures the behavior of replacing all lines in a file which match the `match` parameter regular expression, regardless of whether the specified line is already present in the file.'

    newvalues(true, false)
    defaultto false
  end

  newparam(:encoding) do
    desc 'For files that are not UTF-8 encoded, specify encoding such as iso-8859-1'
    defaultto 'UTF-8'
  end

  newparam(:append_on_no_match) do
    desc 'If true, append line if match is not found. If false, do not append line if a match is not found'
    newvalues(true, false)
    defaultto true
  end

>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
  # Autorequire the file resource if it's being managed
  autorequire(:file) do
    self[:path]
  end

  validate do
<<<<<<< HEAD
    unless self[:line]
      unless (self[:ensure].to_s == 'absent') and (self[:match_for_absence].to_s == 'true') and self[:match]
        raise(Puppet::Error, "line is a required attribute")
      end
    end
    unless self[:path]
      raise(Puppet::Error, "path is a required attribute")
=======
    if self[:replace_all_matches_not_matching_line].to_s == 'true' && self[:multiple].to_s == 'false'
      raise(Puppet::Error, 'multiple must be true when replace_all_matches_not_matching_line is true')
    end
    if self[:replace_all_matches_not_matching_line].to_s == 'true' && self[:replace].to_s == 'false'
      raise(Puppet::Error, 'replace must be true when replace_all_matches_not_matching_line is true')
    end
    unless self[:line]
      unless (self[:ensure].to_s == 'absent') && (self[:match_for_absence].to_s == 'true') && self[:match]
        raise(Puppet::Error, 'line is a required attribute')
      end
    end
    unless self[:path]
      raise(Puppet::Error, 'path is a required attribute')
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
    end
  end
end
