Facter.add("platform_tag") do
  confine :osfamily => "Darwin"
  setcode do
    platform_name = "osx"
    platform_architecture = Facter.value("architecture")
    platform_release = Facter.value("macosx_productversion_major")

    # If any of these are nil, do not return anything
    if platform_name && platform_release && platform_architecture
        [platform_name, platform_release, platform_architecture].join('-')
    end
  end
end

Facter.add("platform_tag") do
  confine :osfamily => "Debian"
  setcode do
    platform_name = Facter.value("operatingsystem").downcase
    platform_architecture = Facter.value("architecture")
    platform_release = platform_name == "ubuntu" ? Facter.value("operatingsystemrelease") : Facter.value("operatingsystemmajrelease")

    # If any of these are nil, do not return anything
    if platform_name && platform_release && platform_architecture
        [platform_name, platform_release, platform_architecture].join('-')
    end
  end
end

Facter.add("platform_tag") do
  confine :operatingsystem => "SLES"
  setcode do
    platform_name = Facter.value("operatingsystem").downcase
    platform_architecture = Facter.value("architecture")

    if match = Facter.value("operatingsystemrelease").match(/^(\d+)/)
      platform_release = match.captures[0]
    end

    # If any of these are nil, do not return anything
    if platform_name && platform_release && platform_architecture
        [platform_name, platform_release, platform_architecture].join('-')
    end
  end
end

Facter.add("platform_tag") do
  confine :osfamily => "Solaris"
  setcode do
    platform_name = Facter.value("operatingsystem").downcase
    # On solaris, architecture returns back i86p instead of i386. Use hardwareisa instead
    platform_architecture = Facter.value("hardwareisa")

    platform_release = Facter.value('kernelrelease').split('.')[1]

    # If any of these are nil, do not return anything
    if platform_name && platform_release && platform_architecture
        [platform_name, platform_release, platform_architecture].join('-')
    end
  end
end

Facter.add("platform_tag") do
  confine :operatingsystem => "AIX"
  setcode do
    platform_name = Facter.value("operatingsystem").downcase
    # architecture also returns something different on aix - just set
    # platform_architecture to 'power'
    platform_architecture = "power"
    # AIX does not have operatingsystemmajrelease - instead we use kernalrelease
    # ( a string such as - '7100', '6100' or '5100' ) and take the first two digits
    # then insert a '.' to get major.minor
    platform_release = Facter.value("kernelrelease")[0..1].insert(1, '.')


    # If any of these are nil, do not return anything
    if platform_name && platform_release && platform_architecture
        [platform_name, platform_release, platform_architecture].join('-')
    end
  end
end

Facter.add("platform_tag") do
  confine :osfamily => "RedHat"
  setcode do
    # For redhat we use el as the platform name unless we are on fedora
    case Facter.value("operatingsystem").downcase
    when "fedora"
      platform_name = "fedora"
    else
      platform_name = "el"
    end
    platform_architecture = Facter.value("architecture")
    platform_release = Facter.value("operatingsystemmajrelease")

    # If any of these are nil, do not return anything
    if platform_name && platform_release && platform_architecture
        [platform_name, platform_release, platform_architecture].join('-')
    end
  end
end
