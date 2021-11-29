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

    #If passed a ports array with one element then make an array that matches the size
    #of the hosts array.
    #If passed a ports array with more than one element make sure it's the same size as
    #the hosts array.
    if ports.size == 1 then
      ports_munge = Array.new( hosts.size, ports[0])
    elsif hosts.size == ports.size then
      ports_munge = ports
    elsif (hosts.size != ports.size) then
        raise(ArgumentError, "`pe_format_urls(): Ports should only contain one element"+
                           "Otherwise hostnames array and ports array must "+
                           "have the same number of entries. hosts has #{hosts.size}"+
                           " entries and ports has #{ports.size} entries")
    end

    hosts.zip(ports_munge).inject([]) { |urls, pair|
      host, port = pair
      urls.push("#{protocol}://#{host}:#{port}")
    }
  end
end
