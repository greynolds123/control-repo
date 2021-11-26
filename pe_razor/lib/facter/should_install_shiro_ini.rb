require 'digest'

Facter.add('should_install_shiro_ini') do
  confine osfamily: 'RedHat'
  setcode do
    shiro_ini_path = '/etc/puppetlabs/razor-server/shiro.ini'
    old_shiro_ini_default_checksums = [
      '248cc3d29e8d3e21c5e4b29317c6f3dfe61436ee7a65e5227a9d7693da3ee26f',
      '641f5f4e47038959fb0f4fb57fc36d1af36fdd169aa4114b9a6152db8b3481c5',
    ]

    next true unless File.exist?(shiro_ini_path)
    shiro_ini_checksum = Digest::SHA256.hexdigest(File.read(shiro_ini_path))
    old_shiro_ini_default_checksums.include?(shiro_ini_checksum)
  end
end
