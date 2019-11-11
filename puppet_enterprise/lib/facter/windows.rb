Facter.add(:common_appdata) do
  confine :kernel => :windows
  setcode do
    require 'win32/dir'
    Dir::COMMON_APPDATA
  end
end
