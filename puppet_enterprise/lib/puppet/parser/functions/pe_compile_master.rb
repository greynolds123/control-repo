module Puppet::Parser::Functions
  newfunction(:pe_compile_master, :type => :rvalue, :doc => <<-EOS
    Returns whether or not the current master is a compile master.
    Based on the assumption the master of masters will have itself
    as its server but compile masters are not. Since this does not
    necessarily hold true in HA deployments, an optional input of
    the replication_mode parameter is accepted. Valid inputs:
    "none", "source", "replica", or nil. If replication mode is
    "source" or "replica", the function will always return false
    because that means the node is the MoM or replica, respectively.
    Otherwise it will return the result of fqdn == servername.
  EOS
  ) do |args|

    # undef gets converted to "" in Puppet by lib/puppet/functions.rb
    valid_inputs = ["source", "replica", "none", nil, ""]
    not_compile_masters = ["source", "replica"]
    replication_mode = args.first
    mom_or_replica = false

    if args.length > 1 then
      raise Puppet::ParseError, ("pe_compile_master(): wrong number of arguments (#{args.length}; must be 0 or 1 if providing replication_mode)")
    end

    if args.length == 1 then
      if not valid_inputs.include? replication_mode
        raise Puppet::ParseError, "pe_compile_master(): invalid argument #{replication_mode}; must be one of 'source', 'replica', 'none', \"\", or nil"
      end

      if not_compile_masters.include? replication_mode
        mom_or_replica = true
      end
    end

    fqdn = lookupvar('fqdn')
    if fqdn.nil?
      raise Puppet::ParseError, ("pe_compile_master(): fqdn fact is required and expected to be set, but it was null")
    end
    servername = function_pe_servername([])
    !(servername.nil? || (servername == fqdn) || mom_or_replica)

  end
end
