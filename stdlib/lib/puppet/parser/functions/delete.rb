#
# delete.rb
#
<<<<<<< HEAD

module Puppet::Parser::Functions
  newfunction(:delete, :type => :rvalue, :doc => <<-EOS
Deletes all instances of a given element from an array, substring from a
string, or key from a hash.

*Examples:*

    delete(['a','b','c','b'], 'b')
    Would return: ['a','c']

    delete({'a'=>1,'b'=>2,'c'=>3}, 'b')
    Would return: {'a'=>1,'c'=>3}

    delete({'a'=>1,'b'=>2,'c'=>3}, ['b','c'])
    Would return: {'a'=>1}

    delete('abracadabra', 'bra')
    Would return: 'acada'
  EOS
  ) do |arguments|

    raise(Puppet::ParseError, "delete(): Wrong number of arguments "+
                              "given #{arguments.size} for 2") unless arguments.size == 2
=======
module Puppet::Parser::Functions
  newfunction(:delete, :type => :rvalue, :doc => <<-DOC
    Deletes all instances of a given element from an array, substring from a
    string, or key from a hash.

    *Examples:*

        delete(['a','b','c','b'], 'b')
        Would return: ['a','c']

        delete({'a'=>1,'b'=>2,'c'=>3}, 'b')
        Would return: {'a'=>1,'c'=>3}

        delete({'a'=>1,'b'=>2,'c'=>3}, ['b','c'])
        Would return: {'a'=>1}

        delete('abracadabra', 'bra')
        Would return: 'acada'
  DOC
             ) do |arguments|

    raise(Puppet::ParseError, "delete(): Wrong number of arguments given #{arguments.size} for 2") unless arguments.size == 2
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870

    collection = arguments[0].dup
    Array(arguments[1]).each do |item|
      case collection
<<<<<<< HEAD
        when Array, Hash
          collection.delete item
        when String
          collection.gsub! item, ''
        else
          raise(TypeError, "delete(): First argument must be an Array, " +
                             "String, or Hash. Given an argument of class #{collection.class}.")
=======
      when Array, Hash
        collection.delete item
      when String
        collection.gsub! item, ''
      else
        raise(TypeError, "delete(): First argument must be an Array, String, or Hash. Given an argument of class #{collection.class}.")
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      end
    end
    collection
  end
end

# vim: set ts=2 sw=2 et :
