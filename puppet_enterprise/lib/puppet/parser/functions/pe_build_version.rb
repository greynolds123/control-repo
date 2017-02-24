require_relative '../../../shared/pe_build'

module Puppet::Parser::Functions
  newfunction(:pe_build_version, :type => :rvalue, :doc => <<-EOS
    Returns the pe build version number on the compiling master.

    This is needed as a function instead of as a fact due to in SG, this file will only exist on the master.
    EOS
  ) do |args|


    if args.length > 0 then
      raise Puppet::ParseError, ("pe_build(): wrong number of arguments (#{args.length}; must be 0)")
    end

    PEBuild.get_pe_build
  end
end
