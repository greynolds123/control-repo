require 'digest/md5'
<<<<<<< HEAD

Puppet::Type.newtype(:ini_setting) do

  ensurable do
    defaultvalues
=======
require 'puppet/parameter/boolean'

Puppet::Type.newtype(:ini_setting) do
  desc 'ini_settings is used to manage a single setting in an INI file'
  ensurable do
    desc 'Ensurable method handles modeling creation. It creates an ensure property'
    newvalue(:present) do
      provider.create
    end
    newvalue(:absent) do
      provider.destroy
    end
    def insync?(current)
      if @resource[:refreshonly]
        true
      else
        current == should
      end
    end
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
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
    munge do |value|
<<<<<<< HEAD
      if value =~ /(^\s|\s$)/
        Puppet.warn("Settings should not have spaces in the value, we are going to strip the whitespace")
      end
      value.lstrip.rstrip
    end
  end

  newparam(:path) do
    desc 'The ini file Puppet will ensure contains the specified setting.'
    validate do |value|
      unless (Puppet.features.posix? and value =~ /^\//) or (Puppet.features.microsoft_windows? and (value =~ /^.:\// or value =~ /^\/\/[^\/]+\/[^\/]+/))
        raise(Puppet::Error, "File paths must be fully qualified, not '#{value}'")
=======
      if value =~ %r{(^\s|\s$)}
        Puppet.warn('Settings should not have spaces in the value, we are going to strip the whitespace')
      end
      value.strip
    end
  end

  newparam(:force_new_section_creation, boolean: true, parent: Puppet::Parameter::Boolean) do
    desc 'Create setting only if the section exists'
    defaultto(true)
  end

  newparam(:path) do
    desc 'The ini file Puppet will ensure contains the specified setting.'
    validate do |value|
      unless Puppet::Util.absolute_path?(value)
        raise(Puppet::Error, _("File paths must be fully qualified, not '%{value}'") % { value: value })
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
      end
    end
  end

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

  newproperty(:value) do
    desc 'The value of the setting to be defined.'

    munge do |value|
<<<<<<< HEAD
      value.to_s
    end

    def should_to_s(newvalue)
      if (@resource[:show_diff] == :true && Puppet[:show_diff]) then
        return newvalue
      elsif (@resource[:show_diff] == :md5 && Puppet[:show_diff]) then
        return '{md5}' + Digest::MD5.hexdigest(newvalue.to_s)
      else
        return '[redacted sensitive information]'
      end
    end

    def is_to_s(value)
=======
      if ([true, false].include? value) || value.is_a?(Numeric)
        value.to_s
      else
        value.strip.to_s
      end
    end

    def should_to_s(newvalue)
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

    def insync?(current)
<<<<<<< HEAD
      if (@resource[:refreshonly]) then
=======
      if @resource[:refreshonly]
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
        true
      else
        current == should
      end
    end
<<<<<<< HEAD

  end

  newparam(:section_prefix) do
    desc 'The prefix to the section name\'s header.' +
      'Defaults to \'[\'.'
=======
  end

  newparam(:section_prefix) do
    desc 'The prefix to the section name\'s header.'
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
    defaultto('[')
  end

  newparam(:section_suffix) do
<<<<<<< HEAD
    desc 'The suffix to the section name\'s header.' +
      'Defaults to \']\'.'
    defaultto(']')
  end

  newparam(:refreshonly) do
    desc 'A flag indicating whether or not the ini_setting should be updated '+
         'only when called as part of a refresh event'
    defaultto false
    newvalues(true,false)
  end

  def refresh
    if self[:refreshonly] then
      # update the value in the provider, which will save the value to the ini file
      provider.value = self[:value]
    end
  end

=======
    desc 'The suffix to the section name\'s header.'
    defaultto(']')
  end

  newparam(:indent_char) do
    desc 'The character to indent new settings with.'
    defaultto(' ')
  end

  newparam(:indent_width) do
    desc 'The number of indent_chars to use to indent a new setting.'
  end

  newparam(:refreshonly, boolean: true, parent: Puppet::Parameter::Boolean) do
    desc 'A flag indicating whether or not the ini_setting should be updated only when called as part of a refresh event'
    defaultto false
  end

  def refresh
    if self[:ensure] == :absent && self[:refreshonly]
      return provider.destroy
    end
    # update the value in the provider, which will save the value to the ini file
    provider.value = self[:value] if self[:refreshonly]
  end

  autorequire(:file) do
    Pathname.new(self[:path]).parent.to_s
  end
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
end
