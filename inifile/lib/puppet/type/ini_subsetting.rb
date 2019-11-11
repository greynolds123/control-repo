require 'digest/md5'

Puppet::Type.newtype(:ini_subsetting) do
<<<<<<< HEAD

  ensurable do
=======
  desc 'ini_subsettings is used to manage multiple values in a setting in an INI file'
  ensurable do
    desc 'Ensurable method handles modeling creation. It creates an ensure property'
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
    defaultvalues
    defaultto :present
  end

  def munge_boolean_md5(value)
    case value
    when true, :true, 'true', :yes, 'yes'
      :true
    when false, :false, 'false', :no, 'no'
      :false
    when :md5, 'md5'
      :md5
    else
<<<<<<< HEAD
      fail('expected a boolean value or :md5')
    end
  end

  newparam(:name, :namevar => true) do
=======
      raise(_('expected a boolean value or :md5'))
    end
  end
  newparam(:name, namevar: true) do
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
    desc 'An arbitrary name used as the identity of the resource.'
  end

  newparam(:section) do
<<<<<<< HEAD
    desc 'The name of the section in the ini file in which the setting should be defined.' +
      'If not provided, defaults to global, top of file, sections.'
    defaultto("")
=======
    desc 'The name of the section in the ini file in which the setting should be defined.'
    defaultto('')
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
  end

  newparam(:setting) do
    desc 'The name of the setting to be defined.'
  end

  newparam(:subsetting) do
    desc 'The name of the subsetting to be defined.'
  end

  newparam(:subsetting_separator) do
<<<<<<< HEAD
    desc 'The separator string between subsettings. Defaults to " "'
    defaultto(" ")
=======
    desc 'The separator string between subsettings. Defaults to the empty string.'
    defaultto(' ')
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
  end

  newparam(:subsetting_key_val_separator) do
    desc 'The separator string between the subsetting name and its value. Defaults to the empty string.'
    defaultto('')
  end

  newparam(:path) do
    desc 'The ini file Puppet will ensure contains the specified setting.'
    validate do |value|
<<<<<<< HEAD
      unless (Puppet.features.posix? and value =~ /^\//) or (Puppet.features.microsoft_windows? and (value =~ /^.:\// or value =~ /^\/\/[^\/]+\/[^\/]+/))
        raise(Puppet::Error, "File paths must be fully qualified, not '#{value}'")
      end
    end
  end

=======
      unless (Puppet.features.posix? && value =~ %r{^\/}) || (Puppet.features.microsoft_windows? && (value =~ %r{^.:\/} || value =~ %r{^\/\/[^\/]+\/[^\/]+}))
        raise(Puppet::Error, _("File paths must be fully qualified, not '%{value}'") % { value: value })
      end
    end
  end
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
  newparam(:show_diff) do
    desc 'Whether to display differences when the setting changes.'
    defaultto :true
    newvalues(:true, :md5, :false)

    munge do |value|
      @resource.munge_boolean_md5(value)
    end
  end

  newparam(:key_val_separator) do
<<<<<<< HEAD
    desc 'The separator string to use between each setting name and value. ' +
        'Defaults to " = ", but you could use this to override e.g. ": ", or' +
        'whether or not the separator should include whitespace.'
    defaultto(" = ")
=======
    desc 'The separator string to use between each setting name and value.'
    defaultto(' = ')
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
  end

  newparam(:quote_char) do
    desc 'The character used to quote the entire value of the setting. ' +
<<<<<<< HEAD
        %q{Valid values are '', '"' and "'". Defaults to ''.}
    defaultto('')

    validate do |value|
      unless value =~ /^["']?$/
        raise Puppet::Error, %q{:quote_char valid values are '', '"' and "'"}
=======
         %q(Valid values are '', '"' and "'")
    defaultto('')

    validate do |value|
      unless value =~ %r{^["']?$}
        raise Puppet::Error, _(%q(:quote_char valid values are '', '"' and "'"))
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
      end
    end
  end

  newparam(:use_exact_match) do
<<<<<<< HEAD
    desc 'Set to true if your subsettings don\'t have values and you want to use exact matches to determine if the subsetting exists. See MODULES-2212'
=======
    desc 'Set to true if your subsettings don\'t have values and you want to use exact matches to determine if the subsetting exists.'
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
    newvalues(:true, :false)
    defaultto(:false)
  end

  newproperty(:value) do
    desc 'The value of the subsetting to be defined.'

    def should_to_s(newvalue)
<<<<<<< HEAD
      if (@resource[:show_diff] == :true && Puppet[:show_diff]) then
        return newvalue
      elsif (@resource[:show_diff] == :md5 && Puppet[:show_diff]) then
        return '{md5}' + Digest::MD5.hexdigest(newvalue.to_s)
      else
        return '[redacted sensitive information]'
      end
    end

    def is_to_s(value)
      should_to_s(value)
    end

    def is_to_s(value)
=======
      if @resource[:show_diff] == :true && Puppet[:show_diff]
        newvalue
      elsif @resource[:show_diff] == :md5 && Puppet[:show_diff]
        '{md5}' + Digest::MD5.hexdigest(newvalue.to_s)
      else
        '[redacted sensitive information]'
      end
    end

    def is_to_s(value) # rubocop:disable Style/PredicateName : Changing breaks the code (./.bundle/gems/gems/puppet-5.3.3-universal-darwin/lib/puppet/parameter.rb:525:in `to_s')
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
      should_to_s(value)
    end
  end

  newparam(:insert_type) do
    desc <<-eof
<<<<<<< HEAD
Where the new subsetting item should be inserted?

* :start  - insert at the beginning of the line.
* :end    - insert at the end of the line (default).
* :before - insert before the specified element if possible.
* :after  - insert after the specified element if possible.
* :index  - insert at the specified index number.
=======
      Where the new subsetting item should be inserted

      * :start  - insert at the beginning of the line.
      * :end    - insert at the end of the line (default).
      * :before - insert before the specified element if possible.
      * :after  - insert after the specified element if possible.
      * :index  - insert at the specified index number.
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
    eof

    newvalues(:start, :end, :before, :after, :index)
    defaultto(:end)
  end

  newparam(:insert_value) do
    desc 'The value for the insert types which require one.'
  end
<<<<<<< HEAD

=======
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
end
