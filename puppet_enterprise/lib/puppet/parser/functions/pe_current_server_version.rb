module Puppet::Parser::Functions
  newfunction(:pe_current_server_version, :type => :rvalue, :doc => <<-EOS
    Returns the current server version number of the master running the puppet agent.
  EOS
  ) do |args|


    if args.length > 0 then
      raise Puppet::ParseError, ("pe_current_server_version(): wrong number of arguments (#{args.length}; must be 0)")
    end

    pe_server_version = function_pe_getvar(['pe_server_version'])
    pe_version = function_pe_getvar(['pe_version'])

    function_pe_pick([pe_server_version, pe_version, 'NOT-INSTALLED'])
  end
end
