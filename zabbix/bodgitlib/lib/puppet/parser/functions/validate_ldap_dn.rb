#
# validate_ldap_dn.rb
#

if RUBY_VERSION < '1.9'
  # :nocov:
  begin
    require 'oniguruma'
  rescue LoadError
    require 'rubygems'
    retry
  end
  # :nocov:
end

module Puppet::Parser::Functions
  newfunction(:validate_ldap_dn, :doc => <<-EOS
    Validate that all passed values are LDAP distinguished names. Abort catalog
    compilation if any value fails this check.
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, 'validate_ldap_dn(): Wrong number of ' +
      "arguments given (#{arguments.size} for 1)") if arguments.size != 1

    # RFC 1779/2253
    re = <<-'EOR'
    ^
    (?<comp>
      (?<tv>
        (?:
          [[:alpha:]] [[:alnum:]_-]*
          |
          (?:
            (?:
              oid
              |
              OID
            )
            \.
          )?
          [[:digit:]]+ (?: \. [[:digit:]]+ )*
        )
        [[:space:]]* = [[:space:]]*
        (?:
          \# (?: [[:xdigit:]]{2} )+
          |
          (?:
            [^,=\+<>#;\\"]
            |
            \\ [,=\+<>#;\\"]
            |
            \\ [[:xdigit:]]{2}
          )*
          |
          "
          (?:
            [^\\"]
            |
            \\ [,=\+<>#;\\"]
            |
            \\ [[:xdigit:]]{2}
          )*
          "
        )
      )
      (?: [[:space:]]* \+ [[:space:]]* \g<tv> )*
    )
    (?: [[:space:]]* [,;] [[:space:]]* \g<comp> )*
    $
    EOR

    if RUBY_VERSION < '1.9'
      # :nocov:
      dn = Oniguruma::ORegexp.new(re, :options => Oniguruma::OPTION_EXTEND)
      # :nocov:
    else
      dn = Regexp.new(re, Regexp::EXTENDED)
    end

    item = arguments[0]

    unless item.is_a?(Array)
      item = [item]
    end

    if item.size == 0
      raise(Puppet::ParseError, 'validate_ldap_dn(): Requires an array ' +
        'with at least 1 element')
    end

    item.each do |i|
      unless i.is_a?(String)
        raise(Puppet::ParseError, 'validate_ldap_dn(): Requires either an ' +
          'array or string to work with')
      end

      unless i =~ dn
        raise(Puppet::ParseError, "#{i.inspect} is not a valid LDAP " +
          "distinguished name")
      end
    end
  end
end
