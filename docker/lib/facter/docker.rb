# docker.rb
Facter.add('docker_version') do
  setcode do
    if File.exists? '/usr/bin/docker'
      docker = Facter::Core::Execution.exec('/usr/bin/docker -v').split(/\s+/)
      version = docker[2].gsub(/,/, "")
      version
    else
      false
    end
  end
end
