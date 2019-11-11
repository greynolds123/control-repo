module PEServerVersion
  def self.get_pe_server_version
    peversionfile = '/opt/puppetlabs/server/pe_version'

    if File.readable? peversionfile and !File.zero? peversionfile
      peversion = File.new(peversionfile).gets.chomp
      pe_ver = peversion.match(/(\d+\.\d+\.\d+)/)
      pe_ver[1] if pe_ver
    else
      nil
    end
  end
end
