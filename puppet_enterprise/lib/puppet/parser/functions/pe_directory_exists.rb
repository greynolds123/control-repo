module Puppet::Parser::Functions
  newfunction(:pe_directory_exists, :type => :rvalue) do |args|
    File.directory?(args[0])
  end
end