module Puppet::Parser::Functions
  newfunction(:pe_compile_master, :type => :rvalue, :doc => <<-EOS
    Returns whether or not the current master is a compile master
  EOS
  ) do |args|


    if args.length > 0 then
      raise Puppet::ParseError, ("pe_compile_master(): wrong number of arguments (#{args.length}; must be 0)")
    end

    fqdn = lookupvar('fqdn')
    if fqdn.nil?
      raise Puppet::ParseError, ("pe_compile_master(): fqdn fact is required and expected to be set, but it was null")
    end
    servername = function_pe_servername([])
    !servername.nil? && (servername != fqdn)
  end
end
