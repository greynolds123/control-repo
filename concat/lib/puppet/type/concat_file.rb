require 'puppet/type/file/owner'
require 'puppet/type/file/group'
require 'puppet/type/file/mode'
require 'puppet/util/checksums'

Puppet::Type.newtype(:concat_file) do
<<<<<<< HEAD
  @doc = "Gets all the file fragments and puts these into the target file.
    This will mostly be used with exported resources.

    example:
      Concat_fragment <<| tag == 'unique_tag' |>>

      concat_file { '/tmp/file':
        tag            => 'unique_tag', # Mandatory
=======
  @doc = <<-DOC
    @summary
      Generates a file with content from fragments sharing a common unique tag.

    @example
      Concat_fragment <<| tag == 'unique_tag' |>>

      concat_file { '/tmp/file':
        tag            => 'unique_tag', # Optional. Default to undef
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
        path           => '/tmp/file',  # Optional. If given it overrides the resource name
        owner          => 'root',       # Optional. Default to undef
        group          => 'root',       # Optional. Default to undef
        mode           => '0644'        # Optional. Default to undef
        order          => 'numeric'     # Optional, Default to 'numeric'
        ensure_newline => false         # Optional, Defaults to false
      }
<<<<<<< HEAD
  "
  ensurable do
=======
  DOC

  ensurable do
    desc <<-DOC
      Specifies whether the destination file should exist. Setting to 'absent' tells Puppet to delete the destination file if it exists, and
      negates the effect of any other parameters.
    DOC

>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
    defaultvalues

    defaultto { :present }
  end

  def exists?
    self[:ensure] == :present
  end

<<<<<<< HEAD
  newparam(:name, :namevar => true) do
    desc "Resource name"
  end

  newparam(:tag) do
    desc "Tag reference to collect all concat_fragment's with the same tag"
  end

  newparam(:path) do
    desc "The output file"
    defaultto do
      resource.value(:name)
    end
  end

  newparam(:owner, :parent => Puppet::Type::File::Owner) do
    desc "Desired file owner."
  end

  newparam(:group, :parent => Puppet::Type::File::Group) do
    desc "Desired file group."
  end

  newparam(:mode, :parent => Puppet::Type::File::Mode) do
    desc "Desired file mode."
  end

  newparam(:order) do
    desc "Controls the ordering of fragments. Can be set to alphabetical or numeric."
    defaultto 'numeric'
  end

  newparam(:backup) do
    desc "Controls the filebucketing behavior of the final file and see File type reference for its use."
    defaultto 'puppet'
  end

  newparam(:replace) do
    desc "Whether to replace a file that already exists on the local system."
=======
  newparam(:tag) do
    desc 'Required. Specifies a unique tag reference to collect all concat_fragments with the same tag.'
  end

  newparam(:path, namevar: true) do
    desc <<-DOC
      Specifies a destination file for the combined fragments. Valid options: a string containing an absolute path. Default value: the
      title of your declared resource.
    DOC

    validate do |value|
      unless Puppet::Util.absolute_path?(value, :posix) || Puppet::Util.absolute_path?(value, :windows)
        raise ArgumentError, _("File paths must be fully qualified, not '%{_value}'") % { _value: value }
      end
    end
  end

  newparam(:owner, parent: Puppet::Type::File::Owner) do
    desc <<-DOC
      Specifies the owner of the destination file. Valid options: a string containing a username or integer containing a uid.
    DOC
  end

  newparam(:group, parent: Puppet::Type::File::Group) do
    desc <<-DOC
      Specifies a permissions group for the destination file. Valid options: a string containing a group name or integer containing a
      gid.
    DOC
  end

  newparam(:mode, parent: Puppet::Type::File::Mode) do
    desc <<-DOC
      Specifies the permissions mode of the destination file. Valid options: a string containing a permission mode value in octal notation.
    DOC
  end

  newparam(:order) do
    desc <<-DOC
      Specifies a method for sorting your fragments by name within the destination file. You can override this setting for individual
      fragments by adjusting the order parameter in their concat::fragment declarations.
    DOC

    newvalues(:alpha, :numeric)

    defaultto :numeric
  end

  newparam(:backup) do
    desc <<-DOC
      Specifies whether (and how) to back up the destination file before overwriting it. Your value gets passed on to Puppet's native file
      resource for execution. Valid options: true, false, or a string representing either a target filebucket or a filename extension
      beginning with ".".'
    DOC

    validate do |value|
      unless [TrueClass, FalseClass, String].include?(value.class)
        raise ArgumentError, _('Backup must be a Boolean or String')
      end
    end
  end

  newparam(:replace, boolean: true, parent: Puppet::Parameter::Boolean) do
    desc 'Specifies whether to overwrite the destination file if it already exists.'
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
    defaultto true
  end

  newparam(:validate_cmd) do
<<<<<<< HEAD
    desc "Validates file."
  end

  newparam(:ensure_newline) do
    desc "Whether to ensure there is a newline after each fragment."
    defaultto false
  end

  # Inherit File parameters
  newparam(:selinux_ignore_defaults) do
  end

  newparam(:selrange) do
  end

  newparam(:selrole) do
  end

  newparam(:seltype) do
  end

  newparam(:seluser) do
  end

  newparam(:show_diff) do
  end
  # End file parameters

  autorequire(:concat_fragment) do
    catalog.resources.collect do |r|
      if r.is_a?(Puppet::Type.type(:concat_fragment)) && r[:tag] == self[:tag]
        r.name
      end
    end.compact
  end

  # Autorequire the file we are generating below
=======
    desc <<-DOC
      Specifies a validation command to apply to the destination file. Requires Puppet version 3.5 or newer. Valid options: a string to
      be passed to a file resource.
    DOC

    validate do |value|
      unless value.is_a?(String)
        raise ArgumentError, _('Validate_cmd must be a String')
      end
    end
  end

  newparam(:ensure_newline, boolean: true, parent: Puppet::Parameter::Boolean) do
    desc "Specifies whether to add a line break at the end of each fragment that doesn't already end in one."
    defaultto false
  end

  newparam(:format) do
    desc <<-DOC
    Specify what data type to merge the fragments as. Valid options: 'plain', 'yaml', 'json', 'json-array', 'json-pretty', 'json-array-pretty'.
    DOC

    newvalues(:plain, :yaml, :json, :'json-array', :'json-pretty', :'json-array-pretty')

    defaultto :plain
  end

  newparam(:force, boolean: true, parent: Puppet::Parameter::Boolean) do
    desc 'Specifies whether to merge data structures, keeping the values with higher order.'

    defaultto false
  end

  newparam(:selinux_ignore_defaults, boolean: true, parent: Puppet::Parameter::Boolean) do
    desc <<-DOC
      See the file type's selinux_ignore_defaults documentention:
      https://docs.puppetlabs.com/references/latest/type.html#file-attribute-selinux_ignore_defaults.
    DOC
  end

  newparam(:selrange) do
    desc "See the file type's selrange documentation: https://docs.puppetlabs.com/references/latest/type.html#file-attribute-selrange"
    validate do |value|
      raise ArgumentError, _('Selrange must be a String') unless value.is_a?(String)
    end
  end

  newparam(:selrole) do
    desc "See the file type's selrole documentation: https://docs.puppetlabs.com/references/latest/type.html#file-attribute-selrole"
    validate do |value|
      raise ArgumentError, _('Selrole must be a String') unless value.is_a?(String)
    end
  end

  newparam(:seltype) do
    desc "See the file type's seltype documentation: https://docs.puppetlabs.com/references/latest/type.html#file-attribute-seltype"
    validate do |value|
      raise ArgumentError, _('Seltype must be a String') unless value.is_a?(String)
    end
  end

  newparam(:seluser) do
    desc "See the file type's seluser documentation: https://docs.puppetlabs.com/references/latest/type.html#file-attribute-seluser"
    validate do |value|
      raise ArgumentError, _('Seluser must be a String') unless value.is_a?(String)
    end
  end

  newparam(:show_diff, boolean: true, parent: Puppet::Parameter::Boolean) do
    desc <<-DOC
      Specifies whether to set the show_diff parameter for the file resource. Useful for hiding secrets stored in hiera from insecure
      reporting methods.
    DOC
  end

  # Autorequire the file we are generating below
  # Why is this necessary ?
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
  autorequire(:file) do
    [self[:path]]
  end

<<<<<<< HEAD
  def should_content
    return @generated_content if @generated_content
    @generated_content = ""
    content_fragments = []

    resources = catalog.resources.select do |r|
      r.is_a?(Puppet::Type.type(:concat_fragment)) && r[:tag] == self[:tag]
    end

    resources.each do |r|
      content_fragments << ["#{r[:order]}___#{r[:name]}", fragment_content(r)]
    end

    if self[:order] == 'numeric'
      sorted = content_fragments.sort do |a, b|
        def decompound(d)
          d.split('___').map { |v| v =~ /^\d+$/ ? v.to_i : v }
        end

        decompound(a[0]) <=> decompound(b[0])
      end
    else
      sorted = content_fragments.sort_by do |a|
        a_order, a_name = a[0].split('__')
        [a_order, a_name]
      end
    end

    @generated_content = sorted.map { |cf| cf[1] }.join

    @generated_content
  end

=======
  def fragments
    # Collect fragments that target this resource by path, title or tag.
    @fragments ||= catalog.resources.map { |resource|
      next unless resource.is_a?(Puppet::Type.type(:concat_fragment))

      if resource[:target] == self[:path] || resource[:target] == title ||
         (resource[:tag] && resource[:tag] == self[:tag])
        resource
      end
    }.compact
  end

  def decompound(d)
    d.split('___', 2).map { |v| (v =~ %r{^\d+$}) ? v.to_i : v }
  end

  def should_content
    return @generated_content if @generated_content
    @generated_content = ''
    content_fragments = []

    fragments.each do |r|
      content_fragments << ["#{r[:order]}___#{r[:name]}", fragment_content(r)]
    end

    sorted = if self[:order] == :numeric
               content_fragments.sort do |a, b|
                 decompound(a[0]) <=> decompound(b[0])
               end
             else
               content_fragments.sort_by do |a|
                 a_order, a_name = a[0].split('__', 2)
                 [a_order, a_name]
               end
             end

    case self[:format]
    when :plain
      @generated_content = sorted.map { |cf| cf[1] }.join
    when :yaml
      content_array = sorted.map do |cf|
        YAML.safe_load(cf[1])
      end
      content_hash = content_array.reduce({}) do |memo, current|
        nested_merge(memo, current)
      end
      @generated_content = content_hash.to_yaml
    when :json, :'json-array', :'json-pretty', :'json-array-pretty'
      content_array = sorted.map do |cf|
        JSON.parse(cf[1])
      end

      if [:json, :'json-pretty'].include?(self[:format])
        content_hash = content_array.reduce({}) do |memo, current|
          nested_merge(memo, current)
        end

        @generated_content =
          if self[:format] == :json
            content_hash.to_json
          else
            JSON.pretty_generate(content_hash)
          end
      else
        @generated_content =
          if self[:format] == :'json-array'
            content_array.to_json
          else
            JSON.pretty_generate(content_array)
          end
      end
    end

    @generated_content
  end

  def nested_merge(hash1, hash2)
    # If a hash is empty, simply return the other
    return hash1 if hash2.empty?
    return hash2 if hash1.empty?

    # Unique merge for arrays
    if hash1.is_a?(Array) && hash2.is_a?(Array)
      return (hash1 + hash2).uniq
    end

    # Deep-merge Hashes; higher order value is kept
    hash1.merge(hash2) do |k, v1, v2|
      if v1.is_a?(Hash) && v2.is_a?(Hash)
        nested_merge(v1, v2)
      elsif v1.is_a?(Array) && v2.is_a?(Array)
        nested_merge(v1, v2)
      else
        # Fail if there are duplicate keys without force
        unless v1 == v2
          unless self[:force]
            err_message = [
              "Duplicate key '#{k}' found with values '#{v1}' and #{v2}'.",
              "Use 'force' attribute to merge keys.",
            ]
            raise(_(err_message.join(' ')))
          end
          Puppet.debug("Key '#{k}': replacing '#{v2}' with '#{v1}'.")
        end
        v1
      end
    end
  end

>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
  def fragment_content(r)
    if r[:content].nil? == false
      fragment_content = r[:content]
    elsif r[:source].nil? == false
      @source = nil
      Array(r[:source]).each do |source|
        if Puppet::FileServing::Metadata.indirection.find(source)
<<<<<<< HEAD
          @source = source 
          break
        end
      end
      self.fail "Could not retrieve source(s) #{r[:source].join(", ")}" unless @source
=======
          @source = source
          break
        end
      end
      raise _('Could not retrieve source(s) %{_array}') % { _array: Array(r[:source]).join(', ') } unless @source
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
      tmp = Puppet::FileServing::Content.indirection.find(@source)
      fragment_content = tmp.content unless tmp.nil?
    end

    if self[:ensure_newline]
<<<<<<< HEAD
      fragment_content<<"\n" unless fragment_content =~ /\n$/
=======
      newline = Puppet::Util::Platform.windows? ? "\r\n" : "\n"
      fragment_content << newline unless fragment_content =~ %r{#{newline}$}
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
    end

    fragment_content
  end

  def generate
    file_opts = {
<<<<<<< HEAD
      :ensure => self[:ensure] == :absent ? :absent : :file,
=======
      ensure: (self[:ensure] == :absent) ? :absent : :file,
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
    }

    [:path,
     :owner,
     :group,
     :mode,
     :replace,
     :backup,
     :selinux_ignore_defaults,
     :selrange,
     :selrole,
     :seltype,
     :seluser,
     :validate_cmd,
     :show_diff].each do |param|
<<<<<<< HEAD
      unless self[param].nil?
        file_opts[param] = self[param]
      end
    end

    metaparams = Puppet::Type.metaparams
    excluded_metaparams = [ :before, :notify, :require, :subscribe, :tag ]
=======
      file_opts[param] = self[param] unless self[param].nil?
    end

    metaparams = Puppet::Type.metaparams
    excluded_metaparams = [:before, :notify, :require, :subscribe, :tag]
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8

    metaparams.reject! { |param| excluded_metaparams.include? param }

    metaparams.each do |metaparam|
<<<<<<< HEAD
      file_opts[metaparam] = self[metaparam] if self[metaparam]
=======
      file_opts[metaparam] = self[metaparam] unless self[metaparam].nil?
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
    end

    [Puppet::Type.type(:file).new(file_opts)]
  end

  def eval_generate
    content = should_content

<<<<<<< HEAD
    if !content.nil? and !content.empty?
      catalog.resource("File[#{self[:path]}]")[:content] = content
    end

    [ catalog.resource("File[#{self[:path]}]") ]
=======
    if !content.nil? && !content.empty?
      catalog.resource("File[#{self[:path]}]")[:content] = content
    end

    [catalog.resource("File[#{self[:path]}]")]
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
  end
end
