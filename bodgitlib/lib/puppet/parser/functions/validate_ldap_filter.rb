#
# validate_ldap_filter.rb
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
  newfunction(:validate_ldap_filter, :doc => <<-EOS
    Validate that all passed values are LDAP filters. Abort catalog
    compilation if any value fails this check.
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, 'validate_ldap_filter(): Wrong number of ' +
      "arguments given (#{arguments.size} for 1)") if arguments.size != 1

    # RFC 2254
    re = <<-'EOR'
    ^
    (?<re>
      \(
        (?:
          [&|] \g<re>+
          |
          ! \g<re>
          |
          (?:
            (?<attr>
              (?:
                [[:alpha:]] [[:alnum:]_-]*
                |
                [[:digit:]]+ (?: \. [[:digit:]]+ )*
              )
              (?:
                ; [[:alpha:]] [[:alnum:]-]*
              )*
            )
            [~<>]? =
            # Not sure this is 100% correct
            (?<value>
              (?:
                \# (?: [[:xdigit:]]{2} )+
                |
                (?:
                  [^,=+<>#;\\"()*]
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
            |
            \g<attr> = \*
            |
            \g<attr> = \g<value>? \* (?: \g<value> \* )* \g<value>?
            |
            (?:
              \g<attr> (?: :dn )?
              (?:
                :
                (?<rule>
                  [[:digit:]]+ (?: \. [[:digit:]]+ )*
                )
              )?
              := \g<value>
              |
              (?: :dn )? : \g<rule> := \g<value>
            )
          )
        )
      \)
    )
    $
    EOR

    if RUBY_VERSION < '1.9'
      # :nocov:
      filter = Oniguruma::ORegexp.new(re, :options => Oniguruma::OPTION_EXTEND)
      # :nocov:
    else
      filter = Regexp.new(re, Regexp::EXTENDED)
    end

    item = arguments[0]

    unless item.is_a?(Array)
      item = [item]
    end

    if item.size == 0
      raise(Puppet::ParseError, 'validate_ldap_filter(): Requires an array ' +
        'with at least 1 element')
    end

    item.each do |i|
      unless i.is_a?(String)
        raise(Puppet::ParseError, 'validate_ldap_filter(): Requires either ' +
          'an array or string to work with')
      end

      unless i =~ filter
        raise(Puppet::ParseError, "#{i.inspect} is not a valid LDAP filter")
      end
    end
  end
end
