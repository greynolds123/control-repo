#
# validate_ldap_uri.rb
#

require 'uri'
require 'uri/ldap'
require 'pathname'

module URI
  class LDAPI < LDAP
    DEFAULT_PORT ||= nil
  end

  @@schemes['LDAPI'] = LDAPI
end

if RUBY_VERSION < '1.9'
  # :nocov:
  module URI
    class << self
      # This is an almost-duplicate of the method as found in 1.8.7
      def parse(uri)
        scheme, userinfo, host, port,
          registry, path, opaque, query, fragment = self.split(uri)

        # Ruby 1.8.7 parses `ldapi://%2fsome%2fpath` such that `%2fsome%2fpath`
        # is the registry attribute whereas 1.9+ parses that correctly as the
        # host(name) attribute so swap them prior to creating the object
        if scheme == 'ldapi' and host.nil? and not registry.nil?
          host, registry = registry, host
        end

        if scheme && @@schemes.include?(scheme.upcase)
          @@schemes[scheme.upcase].new(scheme, userinfo, host, port,
                                       registry, path, opaque, query,
                                       fragment)
        else
          Generic.new(scheme, userinfo, host, port,
                      registry, path, opaque, query,
                      fragment)
        end
      end
    end
  end
  # :nocov:
end

module Puppet::Parser::Functions
  newfunction(:validate_ldap_uri, :doc => <<-EOS
    Validate that all passed values are LDAP URI's. Abort catalog
    compilation if any value fails this check.
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, 'validate_ldap_uri(): Wrong number of ' +
      "arguments given (#{arguments.size} for 1)") if arguments.size != 1

    item = arguments[0]

    unless item.is_a?(Array)
      item = [item]
    end

    if item.size == 0
      raise(Puppet::ParseError, 'validate_ldap_uri(): Requires an array ' +
        'with at least 1 element')
    end

    item.each do |i|
      unless i.is_a?(String)
        raise(Puppet::ParseError, 'validate_ldap_uri(): Requires either an ' +
          'array or string to work with')
      end

      begin
        u = URI(i)
        case u.scheme
        when 'ldap', 'ldaps'
          # Do nothing
        when 'ldapi'
          if not u.host.nil?
            raise if not Pathname.new(URI.unescape(u.host)).absolute?
          end
        else
          raise
        end
        function_validate_ldap_dn([u.dn]) if u.dn and u.dn.length > 0
        # FIXME validate attributes
        if u.scope
          raise unless ['sub', 'one', 'base'].include?(u.scope)
        end
        function_validate_ldap_filter([u.filter]) if u.filter
        # FIXME validate extensions
      rescue
        raise(Puppet::ParseError, "#{i.inspect} is not a valid LDAP URI")
      end
    end
  end
end
