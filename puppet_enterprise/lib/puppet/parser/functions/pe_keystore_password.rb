require 'openssl/digest'

module Puppet::Parser::Functions
  newfunction(:pe_keystore_password, :arity => 2, :type => :rvalue) do |arguments|

    seed   = arguments[0].to_s
    length = arguments[1].to_i

    raise(Puppet::ParseError, "pe_keystore_password(): Invalid length specified " +
      "(#{length}, should be between 1 and 40)") unless length > 0 and length <= 40

    sha1     = OpenSSL::Digest::SHA1.new
    digest   = sha1.digest("#{seed}poppynjazz").unpack("H*")[0]
    password = digest[0 .. length - 1]
  end
end
