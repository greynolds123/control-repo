require 'pathname'

module Puppet::Parser::Functions
  newfunction(:splitpath, :type => :rvalue) do |args|
    if args.length == 1
      # normalize the path to use forward slashes
      original_path = args[0].gsub /\\+/, '/'
      prefix = ''

      if original_path =~ /^[A-z]:/ then
        prefix,original_path = original_path.match(/^([A-z]:)(.*)/i).captures
      end

      path = prefix
      final = []
      Pathname(original_path).each_filename do |a|
        path += '/' + a
        final << path
      end
      return final
    elsif args.length > 1
      raise Puppet::ParseError, "only 1 path may be supplied"
    else
      raise Puppet::ParseError, "path argument required"
    end
  end
end
