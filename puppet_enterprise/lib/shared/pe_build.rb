module PEBuild
  def self.get_pe_build
    pebuildfile = '/opt/puppetlabs/server/pe_build'

    if File.readable? pebuildfile and !File.zero? pebuildfile
      peversion = File.open(pebuildfile, 'r').gets.chomp

      pe_build = peversion.match(/\d+\.\d+\.\d+-?\w*-?\w*-?\w*/)
      return pe_build[0] if pe_build
    else
      nil
    end
  end
end
