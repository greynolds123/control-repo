module Puppet::Parser::Functions
  newfunction(:interval_and_offset_to_cron_time, :type => :rvalue, :doc => <<-EOS
Convert an interval and offset (in minutes) to cron hour and minute fields.
When interval > 30, round up to the nearest hour, to accommodate cron syntax.
    EOS
  ) do |arguments|

    if (arguments.size != 2) then
      raise(Puppet::ParseError, 'interval_and_offset_to_cron_time(): ' +
        "wrong number of arguments given (#{arguments.size} for 2)")
    end

    interval = arguments[0].to_i
    offset   = arguments[1].to_i

    if (interval < 0 || interval > 1440) then
      raise(Puppet::ParseError, 'interval_and_offset_to_cron_time(): ' +
        'interval must be between 0 and 1440')
    end

    if (offset < 0 || offset > 59) then
      raise(Puppet::ParseError, 'interval_and_offset_to_cron_time(): ' +
        'offset must be between 0 and 59')
    end

    if (offset > interval) then
      raise(Puppet::ParseError, 'interval_and_offset_to_cron_time(): ' +
        'offset must be less than or equal to interval')
    end

    case interval
    when 0
      hour   = 'absent'
      minute = 'absent'
    when 1
      # Use '*' instead of generating a list of every minute in an hour.
      hour   = '*'
      minute = '*'
    when 2..30
      # Generate an offset list of interval minutes.
      intervals = 0..((60 / interval) - 1)
      hour   = '*'
      minute = intervals.map { |i| (i * interval + offset) }
    when 31..60
      # Rounding interval up to an hour, to accommodate cron syntax.
      hour   = '*'
      minute = offset
    when 61..1440
      # Rounding interval up to the nearest hour, to accommodate cron syntax.
      hour   = sprintf('*/%d', (interval / 60.0).ceil)
      minute = offset
    end

    result = {
      'hour'   => hour,
      'minute' => minute,
    }

  end
end
