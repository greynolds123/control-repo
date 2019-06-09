# Name spaced sort function from puppetlabs-stdlib
# https://github.com/puppetlabs/puppetlabs-stdlib/blob/master/lib/puppet/parser/functions/sort.rb

module Puppet::Parser::Functions
  newfunction(:pe_sort, :type => :rvalue, :doc => <<-EOS
Sorts strings and arrays lexically.
    EOS
  ) do |arguments|

    if (arguments.size != 1) then
      raise(Puppet::ParseError, "pe_sort(): Wrong number of arguments "+
        "given #{arguments.size} for 1")
    end

    value = arguments[0]

    if value.is_a?(Array) then
      value.sort
    elsif value.is_a?(String) then
      value.split("").sort.join("")
    end

  end
end
