<<<<<<< HEAD
# Returns true if the ipaddress is within the given CIDRs
=======
# @summary
#   Returns true if the ipaddress is within the given CIDRs
>>>>>>> 3e0569df506721e4616112328527bfb8431b063a
#
# @example ip_in_range(<IPv4 Address>, <IPv4 CIDR>)
#   stdlib::ip_in_range('10.10.10.53', '10.10.10.0/24') => true
Puppet::Functions.create_function(:'stdlib::ip_in_range') do
<<<<<<< HEAD
  # @param [String] ipaddress The IP address to check
  # @param [Variant[String, Array]] range One CIDR or an array of CIDRs
=======
  # @param ipaddress The IP address to check
  # @param range One CIDR or an array of CIDRs
>>>>>>> 3e0569df506721e4616112328527bfb8431b063a
  #   defining the range(s) to check against
  #
  # @return [Boolean] True or False
  dispatch :ip_in_range do
    param 'String', :ipaddress
    param 'Variant[String, Array]', :range
    return_type 'Boolean'
  end

  require 'ipaddr'
<<<<<<< HEAD

=======
>>>>>>> 3e0569df506721e4616112328527bfb8431b063a
  def ip_in_range(ipaddress, range)
    ip = IPAddr.new(ipaddress)

    if range.is_a? Array
      ranges = range.map { |r| IPAddr.new(r) }
      ranges.any? { |rng| rng.include?(ip) }
    elsif range.is_a? String
      ranges = IPAddr.new(range)
      ranges.include?(ip)
    end
  end
end
