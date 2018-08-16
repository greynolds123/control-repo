#
# is_domain_name.rb
#
<<<<<<< HEAD

module Puppet::Parser::Functions
  newfunction(:is_domain_name, :type => :rvalue, :doc => <<-EOS
Returns true if the string passed to this function is a syntactically correct domain name.
    EOS
  ) do |arguments|

    if (arguments.size != 1) then
      raise(Puppet::ParseError, "is_domain_name(): Wrong number of arguments "+
        "given #{arguments.size} for 1")
=======
module Puppet::Parser::Functions
  newfunction(:is_domain_name, :type => :rvalue, :doc => <<-DOC
    Returns true if the string passed to this function is a syntactically correct domain name.
    DOC
             ) do |arguments|

    if arguments.size != 1
      raise(Puppet::ParseError, "is_domain_name(): Wrong number of arguments given #{arguments.size} for 1")
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
    end

    # Only allow string types
    return false unless arguments[0].is_a?(String)

    domain = arguments[0].dup

    # Limits (rfc1035, 3.1)
<<<<<<< HEAD
    domain_max_length=255
    label_min_length=1
    label_max_length=63
=======
    domain_max_length = 255
    label_min_length = 1
    label_max_length = 63
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870

    # Allow ".", it is the top level domain
    return true if domain == '.'

    # Remove the final dot, if present.
    domain.chomp!('.')

    # Check the whole domain
    return false if domain.empty?
    return false if domain.length > domain_max_length

    # The top level domain must be alphabetic if there are multiple labels.
    # See rfc1123, 2.1
<<<<<<< HEAD
    return false if domain.include? '.' and not /\.[A-Za-z]+$/.match(domain)
=======
    return false if domain.include?('.') && !%r{\.[A-Za-z]+$}.match(domain)
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870

    # Check each label in the domain
    labels = domain.split('.')
    vlabels = labels.each do |label|
      break if label.length < label_min_length
      break if label.length > label_max_length
      break if label[-1..-1] == '-'
      break if label[0..0] == '-'
<<<<<<< HEAD
      break unless /^[a-z\d-]+$/i.match(label)
    end
    return vlabels == labels

=======
      break unless %r{^[a-z\d-]+$}i =~ label
    end
    return vlabels == labels
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
  end
end

# vim: set ts=2 sw=2 et :
