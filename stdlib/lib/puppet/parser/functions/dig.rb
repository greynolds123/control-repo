#
# dig.rb
#
<<<<<<< HEAD

module Puppet::Parser::Functions
  newfunction(:dig, :type => :rvalue, :doc => <<-EOS
    DEPRECATED: This function has been replaced in Puppet 4.5.0, please use dig44() for backwards compatibility or use the new version.
    EOS
  ) do |arguments|
    warning("dig() DEPRECATED: This function has been replaced in Puppet 4.5.0, please use dig44() for backwards compatibility or use the new version.")
    if ! Puppet::Parser::Functions.autoloader.loaded?(:dig44)
=======
module Puppet::Parser::Functions
  newfunction(:dig, :type => :rvalue, :doc => <<-DOC
    DEPRECATED: This function has been replaced in Puppet 4.5.0, please use dig44() for backwards compatibility or use the new version.
    DOC
             ) do |arguments|
    warning('dig() DEPRECATED: This function has been replaced in Puppet 4.5.0, please use dig44() for backwards compatibility or use the new version.')
    unless Puppet::Parser::Functions.autoloader.loaded?(:dig44)
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      Puppet::Parser::Functions.autoloader.load(:dig44)
    end
    function_dig44(arguments)
  end
end
