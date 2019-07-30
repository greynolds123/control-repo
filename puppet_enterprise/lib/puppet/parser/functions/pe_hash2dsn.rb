module Puppet::Parser::Functions
  newfunction(:pe_hash2dsn, :type => :rvalue, :arity => 1, :doc => <<-EOS
    Converts a puppet hash into a postgres dsn (connection string)
    in key1=val1 key2=val2 format.
  EOS
  ) do |args|
    h = args[0]
    return h.sort
            .select { |k,v| not (v == :undef or v.nil?) }
            .map { |k,v| k.to_s + '=' + v.to_s }
            .join(' ')
  end
end
