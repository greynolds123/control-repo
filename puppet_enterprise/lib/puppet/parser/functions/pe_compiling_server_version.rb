require_relative '../../../shared/pe_server_version'

module Puppet::Parser::Functions
  newfunction(:pe_compiling_server_version, :type => :rvalue, :doc => <<-EOS
    Returns the pe server version number on the compiling master.

    This is needed as a function instead of as a fact due to in SG, this file will only exist on the master.
    EOS
  ) do |args|


    if args.length > 0 then
      raise Puppet::ParseError, ("pe_compiling_server_version(): wrong number of arguments (#{args.length}; must be 0)")
    end

    PEServerVersion.get_pe_server_version
  end
end
