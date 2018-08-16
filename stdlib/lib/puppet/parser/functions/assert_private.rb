#
# assert_private.rb
#
<<<<<<< HEAD

module Puppet::Parser::Functions
  newfunction(:assert_private, :doc => <<-'EOS'
    Sets the current class or definition as private.
    Calling the class or definition from outside the current module will fail.
    EOS
  ) do |args|

    raise(Puppet::ParseError, "assert_private(): Wrong number of arguments "+
      "given (#{args.size}}) for 0 or 1)") if args.size > 1
=======
module Puppet::Parser::Functions
  newfunction(:assert_private, :doc => <<-DOC
    Sets the current class or definition as private.
    Calling the class or definition from outside the current module will fail.
    DOC
             ) do |args|

    raise(Puppet::ParseError, "assert_private(): Wrong number of arguments given (#{args.size}}) for 0 or 1)") if args.size > 1
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870

    scope = self
    if scope.lookupvar('module_name') != scope.lookupvar('caller_module_name')
      message = nil
<<<<<<< HEAD
      if args[0] and args[0].is_a? String
=======
      if args[0] && args[0].is_a?(String)
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
        message = args[0]
      else
        manifest_name = scope.source.name
        manifest_type = scope.source.type
        message = (manifest_type.to_s == 'hostclass') ? 'Class' : 'Definition'
        message += " #{manifest_name} is private"
      end
      raise(Puppet::ParseError, message)
    end
  end
end
