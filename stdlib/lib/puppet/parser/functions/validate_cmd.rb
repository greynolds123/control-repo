require 'puppet/util/execution'
require 'tempfile'

<<<<<<< HEAD
module Puppet::Parser::Functions
  newfunction(:validate_cmd, :doc => <<-'ENDHEREDOC') do |args|
=======
#
# validate_cmd.rb
#
module Puppet::Parser::Functions
  newfunction(:validate_cmd, :doc => <<-'DOC') do |args|
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
    Perform validation of a string with an external command.
    The first argument of this function should be a string to
    test, and the second argument should be a path to a test command
    taking a % as a placeholder for the file path (will default to the end).
    If the command, launched against a tempfile containing the passed string,
    returns a non-null value, compilation will abort with a parse error.

    If a third argument is specified, this will be the error message raised and
    seen by the user.

    A helpful error message can be returned like this:

    Example:

        # Defaults to end of path
        validate_cmd($sudoerscontent, '/usr/sbin/visudo -c -f', 'Visudo failed to validate sudoers content')

        # % as file location
        validate_cmd($haproxycontent, '/usr/sbin/haproxy -f % -c', 'Haproxy failed to validate config content')

<<<<<<< HEAD
    ENDHEREDOC
    if (args.length < 2) or (args.length > 3) then
      raise Puppet::ParseError, ("validate_cmd(): wrong number of arguments (#{args.length}; must be 2 or 3)")
=======
    DOC
    if (args.length < 2) || (args.length > 3)
      raise Puppet::ParseError, "validate_cmd(): wrong number of arguments (#{args.length}; must be 2 or 3)"
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
    end

    msg = args[2] || "validate_cmd(): failed to validate content with command #{args[1].inspect}"

    content = args[0]
    checkscript = args[1]

    # Test content in a temporary file
<<<<<<< HEAD
    tmpfile = Tempfile.new("validate_cmd")
=======
    tmpfile = Tempfile.new('validate_cmd')
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
    begin
      tmpfile.write(content)
      tmpfile.close

<<<<<<< HEAD
      if checkscript =~ /\s%(\s|$)/
        check_with_correct_location = checkscript.gsub(/%/,tmpfile.path)
      else
        check_with_correct_location = "#{checkscript} #{tmpfile.path}"
      end
=======
      check_with_correct_location = if checkscript =~ %r{\s%(\s|$)}
                                      checkscript.gsub(%r{%}, tmpfile.path)
                                    else
                                      "#{checkscript} #{tmpfile.path}"
                                    end
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870

      if Puppet::Util::Execution.respond_to?('execute')
        Puppet::Util::Execution.execute(check_with_correct_location)
      else
        Puppet::Util.execute(check_with_correct_location)
      end
    rescue Puppet::ExecutionFailure => detail
      msg += "\n#{detail}"
      raise Puppet::ParseError, msg
    rescue StandardError => detail
      msg += "\n#{detail.class.name} #{detail}"
      raise Puppet::ParseError, msg
    ensure
      tmpfile.unlink
    end
  end
end
