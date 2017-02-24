module Puppet::Parser::Functions
  newfunction(:pe_servername, :type => :rvalue, :doc => <<-EOS
    Returns the servername in a way that will not cause undefined variable
    reference errors.
  EOS
  ) do |args|


    if args.length > 0 then
      raise Puppet::ParseError, ("pe_servername(): wrong number of arguments (#{args.length}; must be 0)")
    end

    if exist? 'servername'
      return lookupvar('servername')
    else
      return nil
    end
  end
end
