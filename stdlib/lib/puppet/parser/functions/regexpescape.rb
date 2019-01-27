#
#  regexpescape.rb
#
module Puppet::Parser::Functions
<<<<<<< HEAD
  newfunction(:regexpescape, :type => :rvalue, :doc => <<-EOS
    Regexp escape a string or array of strings.
    Requires either a single string or an array as an input.
    EOS
  ) do |arguments| # rubocop:disable Style/ClosingParenthesisIndentation
    raise(Puppet::ParseError, 'regexpescape(): Wrong number of arguments ' \
      "given (#{arguments.size} for 1)") if arguments.empty?
=======
  newfunction(:regexpescape, :type => :rvalue, :doc => <<-DOC
    Regexp escape a string or array of strings.
    Requires either a single string or an array as an input.
    DOC
  ) do |arguments| # rubocop:disable Layout/ClosingParenthesisIndentation
    raise(Puppet::ParseError, "regexpescape(): Wrong number of arguments given (#{arguments.size} for 1)") if arguments.empty?
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19

    value = arguments[0]

    unless value.is_a?(Array) || value.is_a?(String)
<<<<<<< HEAD
      raise(Puppet::ParseError, 'regexpescape(): Requires either ' \
        'array or string to work with')
=======
      raise(Puppet::ParseError, 'regexpescape(): Requires either array or string to work with')
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
    end

    result = if value.is_a?(Array)
               # Numbers in Puppet are often string-encoded which is troublesome ...
<<<<<<< HEAD
               value.collect { |i| i.is_a?(String) ? Regexp.escape(i) : i }
=======
               value.map { |i| i.is_a?(String) ? Regexp.escape(i) : i }
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
             else
               Regexp.escape(value)
             end

    return result
  end
end

# vim: set ts=2 sw=2 et :
