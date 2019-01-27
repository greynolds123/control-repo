Puppet::Type.type(:file_line).provide(:ruby) do
  def exists?
<<<<<<< HEAD
    if resource[:replace].to_s != 'true' and count_matches(match_regex) > 0
      true
    else
      lines.find do |line|
        if resource[:ensure].to_s == 'absent' and resource[:match_for_absence].to_s == 'true'
          line.chomp =~ Regexp.new(resource[:match])
        else
          line.chomp == resource[:line].chomp
        end
      end
    end
  end

  def create
    unless resource[:replace].to_s != 'true' and count_matches(match_regex) > 0
      if resource[:match]
        handle_create_with_match
      elsif resource[:after]
        handle_create_with_after
      else
        append_line
      end
=======
    found = false
    lines_count = 0
    lines.each do |line|
      found = line.chomp == resource[:line]
      if found
        lines_count += 1
      end
    end
    return found = lines_count > 0 if resource[:match].nil?

    match_count = count_matches(new_match_regex)
    found = if resource[:ensure] == :present
              if match_count.zero?
                if lines_count.zero? && resource[:append_on_no_match].to_s == 'false'
                  true # lies, but gets the job done
                elsif lines_count.zero? && resource[:append_on_no_match].to_s != 'false'
                  false
                else
                  true
                end
              elsif resource[:replace_all_matches_not_matching_line].to_s == 'true'
                false # maybe lies, but knows there's still work to do
              elsif lines_count.zero?
                resource[:replace].to_s == 'false'
              else
                true
              end
            elsif match_count.zero?
              if lines_count.zero?
                false
              else
                true
              end
            elsif lines_count.zero?
              resource[:match_for_absence].to_s == 'true'
            else
              true
            end
  end

  def create
    return if resource[:replace].to_s != 'true' && count_matches(new_match_regex) > 0
    if resource[:match]
      handle_create_with_match
    elsif resource[:after]
      handle_create_with_after
    else
      handle_append_line
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
    end
  end

  def destroy
<<<<<<< HEAD
    if resource[:match_for_absence].to_s == 'true' and resource[:match]
=======
    if resource[:match_for_absence].to_s == 'true' && resource[:match]
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      handle_destroy_with_match
    else
      handle_destroy_line
    end
  end

  private
<<<<<<< HEAD
=======

>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
  def lines
    # If this type is ever used with very large files, we should
    #  write this in a different way, using a temp
    #  file; for now assuming that this type is only used on
    #  small-ish config files that can fit into memory without
    #  too much trouble.
<<<<<<< HEAD
    @lines ||= File.readlines(resource[:path])
  end

  def match_regex
    resource[:match] ? Regexp.new(resource[:match]) : nil
  end

  def handle_create_with_match()
    regex_after = resource[:after] ? Regexp.new(resource[:after]) : nil
    match_count = count_matches(match_regex)

    if match_count > 1 && resource[:multiple].to_s != 'true'
     raise Puppet::Error, "More than one line in file '#{resource[:path]}' matches pattern '#{resource[:match]}'"
    end

    File.open(resource[:path], 'w') do |fh|
      lines.each do |l|
        fh.puts(match_regex.match(l) ? resource[:line] : l)
        if (match_count == 0 and regex_after)
          if regex_after.match(l)
            fh.puts(resource[:line])
            match_count += 1 #Increment match_count to indicate that the new line has been inserted.
          end
        end
      end

      if (match_count == 0)
=======

    @lines ||= File.readlines(resource[:path], :encoding => resource[:encoding])
  rescue TypeError => _e
    # Ruby 1.8 doesn't support open_args
    @lines ||= File.readlines(resource[:path])
  end

  def new_after_regex
    resource[:after] ? Regexp.new(resource[:after]) : nil
  end

  def new_match_regex
    resource[:match] ? Regexp.new(resource[:match]) : nil
  end

  def count_matches(regex)
    lines.select { |line|
      if resource[:replace_all_matches_not_matching_line].to_s == 'true'
        line.match(regex) unless line.chomp == resource[:line]
      else
        line.match(regex)
      end
    }.size
  end

  def handle_create_with_match
    after_regex = new_after_regex
    match_regex = new_match_regex
    match_count = count_matches(new_match_regex)

    if match_count > 1 && resource[:multiple].to_s != 'true'
      raise Puppet::Error, "More than one line in file '#{resource[:path]}' matches pattern '#{resource[:match]}'"
    end

    File.open(resource[:path], 'w') do |fh|
      lines.each do |line|
        fh.puts(match_regex.match(line) ? resource[:line] : line)
        next unless match_count.zero? && after_regex
        if after_regex.match(line)
          fh.puts(resource[:line])
          match_count += 1 # Increment match_count to indicate that the new line has been inserted.
        end
      end

      if match_count.zero?
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
        fh.puts(resource[:line])
      end
    end
  end

  def handle_create_with_after
<<<<<<< HEAD
    regex = Regexp.new(resource[:after])
    count = count_matches(regex)

    if count > 1 && resource[:multiple].to_s != 'true'
      raise Puppet::Error, "#{count} lines match pattern '#{resource[:after]}' in file '#{resource[:path]}'.  One or no line must match the pattern."
    end

    File.open(resource[:path], 'w') do |fh|
      lines.each do |l|
        fh.puts(l)
        if regex.match(l) then
          fh.puts(resource[:line])
        end
      end
    end

    if (count == 0) # append the line to the end of the file
      append_line
    end
  end

  def count_matches(regex)
    lines.select{|l| l.match(regex)}.size
  end

  def handle_destroy_with_match
    match_count = count_matches(match_regex)
    if match_count > 1 && resource[:multiple].to_s != 'true'
     raise Puppet::Error, "More than one line in file '#{resource[:path]}' matches pattern '#{resource[:match]}'"
    end

    local_lines = lines
    File.open(resource[:path],'w') do |fh|
      fh.write(local_lines.reject{|l| match_regex.match(l) }.join(''))
=======
    after_regex = new_after_regex
    after_count = count_matches(after_regex)

    if after_count > 1 && resource[:multiple].to_s != 'true'
      raise Puppet::Error, "#{after_count} lines match pattern '#{resource[:after]}' in file '#{resource[:path]}'. One or no line must match the pattern."
    end

    File.open(resource[:path], 'w') do |fh|
      lines.each do |line|
        fh.puts(line)
        if after_regex.match(line)
          fh.puts(resource[:line])
        end
      end

      if after_count.zero?
        fh.puts(resource[:line])
      end
    end
  end

  def handle_destroy_with_match
    match_regex = new_match_regex
    match_count = count_matches(match_regex)
    if match_count > 1 && resource[:multiple].to_s != 'true'
      raise Puppet::Error, "More than one line in file '#{resource[:path]}' matches pattern '#{resource[:match]}'"
    end

    local_lines = lines
    File.open(resource[:path], 'w') do |fh|
      fh.write(local_lines.reject { |line| match_regex.match(line) }.join(''))
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
    end
  end

  def handle_destroy_line
    local_lines = lines
<<<<<<< HEAD
    File.open(resource[:path],'w') do |fh|
      fh.write(local_lines.reject{|l| l.chomp == resource[:line] }.join(''))
    end
  end

  ##
  # append the line to the file.
  #
  # @api private
  def append_line
    File.open(resource[:path], 'w') do |fh|
      lines.each do |l|
        fh.puts(l)
      end
      fh.puts resource[:line]
=======
    File.open(resource[:path], 'w') do |fh|
      fh.write(local_lines.reject { |line| line.chomp == resource[:line] }.join(''))
    end
  end

  def handle_append_line
    local_lines = lines
    File.open(resource[:path], 'w') do |fh|
      local_lines.each do |line|
        fh.puts(line)
      end
      fh.puts(resource[:line])
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
    end
  end
end
