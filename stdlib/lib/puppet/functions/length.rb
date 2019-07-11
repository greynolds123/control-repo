<<<<<<< HEAD
# A function to eventually replace the old size() function for stdlib - The original size function did not handle Puppets new type capabilities, so this function is a Puppet 4 compatible solution.
=======
# A function to eventually replace the old size() function for stdlib
# The original size function did not handle Puppets new type capabilities, so this function is a Puppet 4 compatible solution.
#
# Note: from Puppet 6.0.0, the compatible function with the same name in Puppet core
# will be used instead of this function.
#
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
Puppet::Functions.create_function(:length) do
  dispatch :length do
    param 'Variant[String,Array,Hash]', :value
  end
  def length(value)
    if value.is_a?(String)
      result = value.length
    elsif value.is_a?(Array) || value.is_a?(Hash)
      result = value.size
    end
    result
  end
end
