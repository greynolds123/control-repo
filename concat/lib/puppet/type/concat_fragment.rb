Puppet::Type.newtype(:concat_fragment) do
<<<<<<< HEAD
  @doc = "Create a concat fragment to be used by concat.
    the `concat_fragment` type creates a file fragment to be collected by concat based on the tag.
    The example is based on exported resources.

    Example:
    @@concat_fragment { \"uniqe_name_${::fqdn}\":
      tag => 'unique_name',
      order => 10, # Optional. Default to 10
      content => 'some content' # OR
      content => template('template.erb') # OR
      source  => 'puppet:///path/to/file'
    }
  "

  newparam(:name, :namevar => true) do
    desc "Unique name"
  end

  newparam(:target) do
    desc "Target"
  end

  newparam(:content) do
    desc "Content"
  end

  newparam(:source) do
    desc "Source"
  end

  newparam(:order) do
    desc "Order"
    defaultto '10'
    validate do |val|
      fail Puppet::ParseError, '$order is not a string or integer.' if !(val.is_a? String or val.is_a? Integer)
      fail Puppet::ParseError, "Order cannot contain '/', ':', or '\n'." if val.to_s =~ /[:\n\/]/
=======
  @doc = <<-DOC
    @summary
      Manages the fragment.

    @example
      # The example is based on exported resources.

      concat_fragment { \"uniqe_name_${::fqdn}\":
        tag => 'unique_name',
        order => 10, # Optional. Default to 10
        content => 'some content' # OR
        # content => template('template.erb')
        source  => 'puppet:///path/to/file'
      }
  DOC

  newparam(:name, namevar: true) do
    desc 'Name of resource.'
  end

  newparam(:target) do
    desc <<-DOC
      Required. Specifies the destination file of the fragment. Valid options: a string containing the path or title of the parent
      concat_file resource.
    DOC

    validate do |value|
      raise ArgumentError, _('Target must be a String') unless value.is_a?(String)
    end
  end

  newparam(:content) do
    desc <<-DOC
      Supplies the content of the fragment. Note: You must supply either a content parameter or a source parameter. Valid options: a string
    DOC

    validate do |value|
      raise ArgumentError, _('Content must be a String') unless value.is_a?(String)
    end
  end

  newparam(:source) do
    desc <<-DOC
      Specifies a file to read into the content of the fragment. Note: You must supply either a content parameter or a source parameter.
      Valid options: a string or an array, containing one or more Puppet URLs.
    DOC

    validate do |value|
      raise ArgumentError, _('Content must be a String or Array') unless [String, Array].include?(value.class)
    end
  end

  newparam(:order) do
    desc <<-DOC
      Reorders your fragments within the destination file. Fragments that share the same order number are ordered by name. The string
      option is recommended.
    DOC

    defaultto '10'
    validate do |val|
      raise Puppet::ParseError, _('$order is not a string or integer.') unless val.is_a?(String) || val.is_a?(Integer)
      raise Puppet::ParseError, _('Order cannot contain \'/\', \':\', or \'\\n\'.') if val.to_s =~ %r{[:\n\/]}
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
    end
  end

  newparam(:tag) do
<<<<<<< HEAD
    desc "Tag name to be used by concat to collect all concat_fragments by tag name"
  end

  autorequire(:file) do
    if catalog.resources.select {|x| x.class == Puppet::Type::Concat_file and (x[:path] == self[:target] || x[:name] == self[:target]) }.empty?
      warning "Target Concat_file with path of #{self[:target]} not found in the catalog"
=======
    desc 'Specifies a unique tag to be used by concat_file to reference and collect content.'
  end

  autorequire(:file) do
    found = catalog.resources.select do |resource|
      next unless resource.is_a?(Puppet::Type.type(:concat_file))

      resource[:path] == self[:target] || resource.title == self[:target] ||
        (resource[:tag] && resource[:tag] == self[:tag])
    end

    if found.empty?
      tag_message = (self[:tag]) ? "or tag '#{self[:tag]} " : ''
      warning "Target Concat_file with path or title '#{self[:target]}' #{tag_message}not found in the catalog"
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
    end
  end

  validate do
    # Check if target is set
<<<<<<< HEAD
    fail Puppet::ParseError, "Target not set" if self[:target].nil?

    # Check if tag is set
    fail Puppet::ParseError, "Tag not set" if self[:tag].nil?

    # Check if either source or content is set. raise error if none is set
    fail Puppet::ParseError, "Set either 'source' or 'content'" if self[:source].nil? && self[:content].nil?

    # Check if both are set, if so rais error
    fail Puppet::ParseError, "Can't use 'source' and 'content' at the same time" if !self[:source].nil? && !self[:content].nil?
=======
    raise Puppet::ParseError, _("No 'target' or 'tag' set") unless self[:target] || self[:tag]

    # Check if either source or content is set. raise error if none is set
    raise Puppet::ParseError, _("Set either 'source' or 'content'") if self[:source].nil? && self[:content].nil?

    # Check if both are set, if so rais error
    raise Puppet::ParseError, _("Can't use 'source' and 'content' at the same time") if !self[:source].nil? && !self[:content].nil?
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
  end
end
