#
# fqdn_rotate.rb
#
<<<<<<< HEAD

=======
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
Puppet::Parser::Functions.newfunction(
  :fqdn_rotate,
  :type => :rvalue,
  :doc => "Usage: `fqdn_rotate(VALUE, [SEED])`. VALUE is required and
  must be an array or a string. SEED is optional and may be any number
  or string.

  Rotates VALUE a random number of times, combining the `$fqdn` fact and
  the value of SEED for repeatable randomness. (That is, each node will
  get a different random rotation from this function, but a given node's
  result will be the same every time unless its hostname changes.) Adding
<<<<<<< HEAD
  a SEED can be useful if you need more than one unrelated rotation.") do |args|

    raise(Puppet::ParseError, "fqdn_rotate(): Wrong number of arguments " +
      "given (#{args.size} for 1)") if args.size < 1

    value = args.shift
    require 'digest/md5'

    unless value.is_a?(Array) || value.is_a?(String)
      raise(Puppet::ParseError, 'fqdn_rotate(): Requires either ' +
        'array or string to work with')
    end

    result = value.clone

    string = value.is_a?(String) ? true : false

    # Check whether it makes sense to rotate ...
    return result if result.size <= 1

    # We turn any string value into an array to be able to rotate ...
    result = string ? result.split('') : result

    elements = result.size

    seed = Digest::MD5.hexdigest([lookupvar('::fqdn'),args].join(':')).hex
    # deterministic_rand() was added in Puppet 3.2.0; reimplement if necessary
    if Puppet::Util.respond_to?(:deterministic_rand)
      offset = Puppet::Util.deterministic_rand(seed, elements).to_i
    else
      if defined?(Random) == 'constant' && Random.class == Class
        offset = Random.new(seed).rand(elements)
      else
        old_seed = srand(seed)
        offset = rand(elements)
        srand(old_seed)
      end
    end
    offset.times {
       result.push result.shift
    }

    result = string ? result.join : result

    return result
=======
  a SEED can be useful if you need more than one unrelated rotation.",
) do |args|

  raise(Puppet::ParseError, "fqdn_rotate(): Wrong number of arguments given (#{args.size} for 1)") if args.empty?

  value = args.shift
  require 'digest/md5'

  unless value.is_a?(Array) || value.is_a?(String)
    raise(Puppet::ParseError, 'fqdn_rotate(): Requires either array or string to work with')
  end

  result = value.clone

  string = value.is_a?(String) ? true : false

  # Check whether it makes sense to rotate ...
  return result if result.size <= 1

  # We turn any string value into an array to be able to rotate ...
  result = string ? result.split('') : result

  elements = result.size

  seed = Digest::MD5.hexdigest([lookupvar('::fqdn'), args].join(':')).hex
  # deterministic_rand() was added in Puppet 3.2.0; reimplement if necessary
  if Puppet::Util.respond_to?(:deterministic_rand)
    offset = Puppet::Util.deterministic_rand(seed, elements).to_i
  else
    return offset = Random.new(seed).rand(elements) if defined?(Random) == 'constant' && Random.class == Class

    old_seed = srand(seed)
    offset = rand(elements)
    srand(old_seed)
  end
  offset.times do
    result.push result.shift
  end

  result = string ? result.join : result

  return result
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
end

# vim: set ts=2 sw=2 et :
