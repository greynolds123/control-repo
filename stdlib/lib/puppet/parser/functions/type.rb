#
# type.rb
#
module Puppet::Parser::Functions
  newfunction(:type, :type => :rvalue, :doc => <<-DOC
<<<<<<< HEAD
    DEPRECATED: This function will cease to function on Puppet 4; please use type3x() before upgrading to puppet 4 for backwards-compatibility, or migrate to the new parser's typing system.
=======
    DEPRECATED: This function will cease to function on Puppet 4; please use type3x() before upgrading to Puppet 4 for backwards-compatibility, or migrate to the new parser's typing system.
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
  DOC
             ) do |args|

    warning("type() DEPRECATED: This function will cease to function on Puppet 4; please use type3x() before upgrading to puppet 4 for backwards-compatibility, or migrate to the new parser's typing system.") # rubocop:disable Metrics/LineLength : Cannot reduce line length
    unless Puppet::Parser::Functions.autoloader.loaded?(:type3x)
      Puppet::Parser::Functions.autoloader.load(:type3x)
    end
    function_type3x(args)
  end
end

# vim: set ts=2 sw=2 et :
