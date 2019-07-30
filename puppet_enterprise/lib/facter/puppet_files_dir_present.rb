# This fact checks if the puppet files directory exists
Facter.add(:puppet_files_dir_present) do
  setcode do
    File.directory?('/etc/puppetlabs/puppet/files')
  end
end
