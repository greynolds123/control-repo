#
# type.rb
#
<<<<<<< HEAD

module Puppet::Parser::Functions
  newfunction(:type, :type => :rvalue, :doc => <<-EOS
  DEPRECATED: This function will cease to function on Puppet 4; please use type3x() before upgrading to puppet 4 for backwards-compatibility, or migrate to the new parser's typing system.
    EOS
  ) do |args|

    warning("type() DEPRECATED: This function will cease to function on Puppet 4; please use type3x() before upgrading to puppet 4 for backwards-compatibility, or migrate to the new parser's typing system.")
    if ! Puppet::Parser::Functions.autoloader.loaded?(:type3x)
      Puppet::Parser::Functions.autoloader.load(:type3x)
    end
    function_type3x(args + [false])
=======
module Puppet::Parser::Functions
  newfunction(:type, :type => :rvalue, :doc => <<-DOC
    DEPRECATED: This function will cease to function on Puppet 4; please use type3x() before upgrading to puppet 4 for backwards-compatibility, or migrate to the new parser's typing system.
  DOC
             ) do |args|

    warning("type() DEPRECATED: This function will cease to function on Puppet 4; please use type3x() before upgrading to puppet 4 for backwards-compatibility, or migrate to the new parser's typing system.") # rubocop:disable Metrics/LineLength : Cannot reduce line length
    unless Puppet::Parser::Functions.autoloader.loaded?(:type3x)
      Puppet::Parser::Functions.autoloader.load(:type3x)
    end
    function_type3x(args)
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
  end
end

# vim: set ts=2 sw=2 et :
