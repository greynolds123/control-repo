require 'pathname'

module Puppet::Parser::Functions
  newfunction(:getparent, :type => :rvalue) do |args|
    if args.length == 1
      # normalize the path to use forward slashes
      original_path = args[0].gsub /\\+/, '/'
      return Pathname(original_path).parent.to_s
    elsif args.length > 1
      raise Puppet::ParseError, "only 1 path may be supplied"
    else
      raise Puppet::ParseError, "path argument required"
    end
  end
end
