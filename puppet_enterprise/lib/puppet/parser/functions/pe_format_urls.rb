module Puppet::Parser::Functions
  newfunction(:pe_format_urls, :type => :rvalue, :arity => -3, :doc => <<-EOS
The first arg is a protocol.
The second arg is an array of hostnames.
The third arg is an of ports.
Returns a list of urls.
    EOS
             ) do |args|

    if (args.size != 3) then
      raise(ArgumentError, "pe_format_urls(): Wrong number of arguments "+
                           "given #{args.size} for 3.")
    end

    protocol, hosts, ports = args

    if (hosts.size != ports.size) then
      raise(ArgumentError, "`pe_format_urls(): Hostnames array and ports array must "+
                           "have the same number of entries")
    end

    hosts.zip(ports).inject([]) { |urls, pair|
      host, port = pair
      urls.push("#{protocol}://#{host}:#{port}")
    }
  end
end
