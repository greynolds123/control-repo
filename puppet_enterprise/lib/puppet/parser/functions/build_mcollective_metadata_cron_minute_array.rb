module Puppet::Parser::Functions
  newfunction(:build_mcollective_metadata_cron_minute_array, :type => :rvalue, :doc => <<-EOS
Build an array of times from an interval and offset.
    EOS
  ) do |arguments|

    if (arguments.size != 2) then
      raise(Puppet::ParseError, "build_mcollective_metadata_cron_minute_array(): Wrong number of arguments "+
        "given #{arguments.size} for 2")
    end

    interval = arguments[0]
    offset   = arguments[1]

    base_array = 0..((60 / interval) -1)

    output_array = []

    base_array.each do | i |
      output_array <<  (i*interval + offset)
    end

    output_array

  end
end
