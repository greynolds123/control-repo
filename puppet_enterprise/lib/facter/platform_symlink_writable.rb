# This fact checks if convenience links path is writable
Facter.add(:platform_symlink_writable) do
  confine do
    Facter.value(:kernel) != 'windows'
  end
  setcode do
    if File.exist?('/usr/local/bin')
      File.writable?('/usr/local/bin')
    elsif File.exist?('/usr/local')
      File.writable?('/usr/local')
    else
      File.writable?('/usr')
    end
  end
end

Facter.add(:platform_symlink_writable) do
  confine do
    Facter.value(:kernel) == 'windows'
  end
  setcode do
    false
  end
end
