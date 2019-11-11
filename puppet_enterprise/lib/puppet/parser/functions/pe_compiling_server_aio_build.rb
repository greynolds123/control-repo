require_relative '../../../shared/aio_build'

module Puppet::Parser::Functions
  newfunction(:pe_compiling_server_aio_build, :type => :rvalue, :doc => <<-EOS
    Returns the aio puppet agent version number on the compiling master.

    Allows compiling master to compare its aio build with the target node's.  Necessary to gate upgrades for LEI.
    EOS
  ) do |args|


    if args.length > 0 then
      raise Puppet::ParseError, ("pe_compiling_server_aio_build(): wrong number of arguments (#{args.length}; must be 0)")
    end

    AIOAgentBuild.get_aio_build
  end
end
