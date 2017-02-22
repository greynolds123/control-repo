apt_package_updates = nil
Facter.add("apt_has_updates") do
  confine :osfamily => 'Debian'
<<<<<<< HEAD
  if File.executable?("/usr/bin/apt-get")
    apt_get_result = Facter::Util::Resolution.exec('/usr/bin/apt-get -s upgrade 2>&1')
    if not apt_get_result.nil?
      apt_package_updates = [[], []]
      apt_get_result.each_line do |line|
        if line =~ /^Inst\s/
          package = line.gsub(/^Inst\s([^\s]+)\s.*/, '\1').strip
          apt_package_updates[0].push(package)
          security_matches = [
            / Debian[^\s]+-updates /,
            / Debian-Security:/,
            / Ubuntu[^\s]+-security /,
            / gNewSense[^\s]+-security /
          ]
          re = Regexp.union(security_matches)
          if line.match(re)
            apt_package_updates[1].push(package)
          end
        end
      end
=======
  if File.executable?("/usr/lib/update-notifier/apt-check")
    apt_check_result = Facter::Util::Resolution.exec('/usr/lib/update-notifier/apt-check 2>&1')
    if not apt_check_result.nil? and apt_check_result =~ /^\d+;\d+$/
      apt_package_updates = apt_check_result.split(';')
>>>>>>> 61a94e602d9e9814c0d27f76e0942de0d08f50a1
    end
  end

  setcode do
    if not apt_package_updates.nil? and apt_package_updates.length == 2
<<<<<<< HEAD
      apt_package_updates != [[], []]
=======
      apt_package_updates != ['0', '0']
>>>>>>> 61a94e602d9e9814c0d27f76e0942de0d08f50a1
    end
  end
end

Facter.add("apt_package_updates") do
  confine :apt_has_updates => true
  setcode do
<<<<<<< HEAD
    if Facter.version < '2.0.0'
      apt_package_updates[0].join(',')
    else
      apt_package_updates[0]
=======
    packages = Facter::Util::Resolution.exec('/usr/lib/update-notifier/apt-check -p 2>&1').split("\n")
    if Facter.version < '2.0.0'
      packages.join(',')
    else
      packages
>>>>>>> 61a94e602d9e9814c0d27f76e0942de0d08f50a1
    end
  end
end

Facter.add("apt_updates") do
  confine :apt_has_updates => true
  setcode do
<<<<<<< HEAD
    Integer(apt_package_updates[0].length)
=======
    Integer(apt_package_updates[0])
>>>>>>> 61a94e602d9e9814c0d27f76e0942de0d08f50a1
  end
end

Facter.add("apt_security_updates") do
  confine :apt_has_updates => true
  setcode do
<<<<<<< HEAD
    Integer(apt_package_updates[1].length)
=======
    Integer(apt_package_updates[1])
>>>>>>> 61a94e602d9e9814c0d27f76e0942de0d08f50a1
  end
end
