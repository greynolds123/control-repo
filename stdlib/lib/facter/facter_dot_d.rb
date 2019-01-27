# A Facter plugin that loads facts from /etc/facter/facts.d
# and /etc/puppetlabs/facter/facts.d.
#
# Facts can be in the form of JSON, YAML or Text files
# and any executable that returns key=value pairs.
#
# In the case of scripts you can also create a file that
# contains a cache TTL.  For foo.sh store the ttl as just
# a number in foo.sh.ttl
#
# The cache is stored in $libdir/facts_dot_d.cache as a mode
# 600 file and will have the end result of not calling your
# fact scripts more often than is needed
<<<<<<< HEAD

class Facter::Util::DotD
  require 'yaml'

  def initialize(dir="/etc/facts.d", cache_file=File.join(Puppet[:libdir], "facts_dot_d.cache"))
    @dir = dir
    @cache_file = cache_file
    @cache = nil
    @types = {".txt" => :txt, ".json" => :json, ".yaml" => :yaml}
  end

  def entries
    Dir.entries(@dir).reject { |f| f =~ /^\.|\.ttl$/ }.sort.map { |f| File.join(@dir, f) }
=======
class Facter::Util::DotD
  require 'yaml'

  def initialize(dir = '/etc/facts.d', cache_file = File.join(Puppet[:libdir], 'facts_dot_d.cache'))
    @dir = dir
    @cache_file = cache_file
    @cache = nil
    @types = { '.txt' => :txt, '.json' => :json, '.yaml' => :yaml }
  end

  def entries
    Dir.entries(@dir).reject { |f| f =~ %r{^\.|\.ttl$} }.sort.map { |f| File.join(@dir, f) }
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
  rescue
    []
  end

  def fact_type(file)
    extension = File.extname(file)

    type = @types[extension] || :unknown

    type = :script if type == :unknown && File.executable?(file)

<<<<<<< HEAD
    return type
=======
    type
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
  end

  def txt_parser(file)
    File.readlines(file).each do |line|
<<<<<<< HEAD
      if line =~ /^([^=]+)=(.+)$/
        var = $1; val = $2

        Facter.add(var) do
          setcode { val }
        end
=======
      next unless line =~ %r{^([^=]+)=(.+)$}
      var = Regexp.last_match(1)
      val = Regexp.last_match(2)

      Facter.add(var) do
        setcode { val }
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      end
    end
  rescue StandardError => e
    Facter.warn("Failed to handle #{file} as text facts: #{e.class}: #{e}")
  end

  def json_parser(file)
    begin
      require 'json'
    rescue LoadError
      retry if require 'rubygems'
      raise
    end

<<<<<<< HEAD
    JSON.load(File.read(file)).each_pair do |f, v|
=======
    JSON.parse(File.read(file)).each_pair do |f, v|
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      Facter.add(f) do
        setcode { v }
      end
    end
  rescue StandardError => e
    Facter.warn("Failed to handle #{file} as json facts: #{e.class}: #{e}")
  end

  def yaml_parser(file)
    require 'yaml'

    YAML.load_file(file).each_pair do |f, v|
      Facter.add(f) do
        setcode { v }
      end
    end
  rescue StandardError => e
    Facter.warn("Failed to handle #{file} as yaml facts: #{e.class}: #{e}")
  end

  def script_parser(file)
    result = cache_lookup(file)
    ttl = cache_time(file)

<<<<<<< HEAD
    unless result
=======
    if result
      Facter.debug("Using cached data for #{file}")
    else
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      result = Facter::Util::Resolution.exec(file)

      if ttl > 0
        Facter.debug("Updating cache for #{file}")
        cache_store(file, result)
        cache_save!
      end
<<<<<<< HEAD
    else
      Facter.debug("Using cached data for #{file}")
    end

    result.split("\n").each do |line|
      if line =~ /^(.+)=(.+)$/
        var = $1; val = $2

        Facter.add(var) do
          setcode { val }
        end
=======
    end

    result.split("\n").each do |line|
      next unless line =~ %r{^(.+)=(.+)$}
      var = Regexp.last_match(1)
      val = Regexp.last_match(2)

      Facter.add(var) do
        setcode { val }
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      end
    end
  rescue StandardError => e
    Facter.warn("Failed to handle #{file} as script facts: #{e.class}: #{e}")
    Facter.debug(e.backtrace.join("\n\t"))
  end

  def cache_save!
    cache = load_cache
<<<<<<< HEAD
    File.open(@cache_file, "w", 0600) { |f| f.write(YAML.dump(cache)) }
  rescue
=======
    File.open(@cache_file, 'w', 0o600) { |f| f.write(YAML.dump(cache)) }
  rescue # rubocop:disable Lint/HandleExceptions
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
  end

  def cache_store(file, data)
    load_cache

<<<<<<< HEAD
    @cache[file] = {:data => data, :stored => Time.now.to_i}
  rescue
=======
    @cache[file] = { :data => data, :stored => Time.now.to_i }
  rescue # rubocop:disable Lint/HandleExceptions
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
  end

  def cache_lookup(file)
    cache = load_cache

    return nil if cache.empty?

    ttl = cache_time(file)

<<<<<<< HEAD
    if cache[file]
      now = Time.now.to_i

      return cache[file][:data] if ttl == -1
      return cache[file][:data] if (now - cache[file][:stored]) <= ttl
      return nil
    else
      return nil
    end
=======
    return nil unless cache[file]
    now = Time.now.to_i

    return cache[file][:data] if ttl == -1
    return cache[file][:data] if (now - cache[file][:stored]) <= ttl
    return nil
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
  rescue
    return nil
  end

  def cache_time(file)
<<<<<<< HEAD
    meta = file + ".ttl"
=======
    meta = file + '.ttl'
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19

    return File.read(meta).chomp.to_i
  rescue
    return 0
  end

  def load_cache
<<<<<<< HEAD
    unless @cache
      if File.exist?(@cache_file)
        @cache = YAML.load_file(@cache_file)
      else
        @cache = {}
      end
    end
=======
    @cache ||= if File.exist?(@cache_file)
                 YAML.load_file(@cache_file)
               else
                 {}
               end
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19

    return @cache
  rescue
    @cache = {}
    return @cache
  end

  def create
    entries.each do |fact|
      type = fact_type(fact)
      parser = "#{type}_parser"

<<<<<<< HEAD
      if respond_to?("#{type}_parser")
        Facter.debug("Parsing #{fact} using #{parser}")

        send(parser, fact)
      end
=======
      next unless respond_to?("#{type}_parser")
      Facter.debug("Parsing #{fact} using #{parser}")

      send(parser, fact)
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
    end
  end
end

<<<<<<< HEAD

mdata = Facter.version.match(/(\d+)\.(\d+)\.(\d+)/)
if mdata
  (major, minor, patch) = mdata.captures.map { |v| v.to_i }
  if major < 2
    # Facter 1.7 introduced external facts support directly
    unless major == 1 and minor > 6
      Facter::Util::DotD.new("/etc/facter/facts.d").create
      Facter::Util::DotD.new("/etc/puppetlabs/facter/facts.d").create

      # Windows has a different configuration directory that defaults to a vendor
      # specific sub directory of the %COMMON_APPDATA% directory.
      if Dir.const_defined? 'COMMON_APPDATA' then
=======
mdata = Facter.version.match(%r{(\d+)\.(\d+)\.(\d+)})
if mdata
  (major, minor, _patch) = mdata.captures.map { |v| v.to_i }
  if major < 2
    # Facter 1.7 introduced external facts support directly
    unless major == 1 && minor > 6
      Facter::Util::DotD.new('/etc/facter/facts.d').create
      Facter::Util::DotD.new('/etc/puppetlabs/facter/facts.d').create

      # Windows has a different configuration directory that defaults to a vendor
      # specific sub directory of the %COMMON_APPDATA% directory.
      if Dir.const_defined? 'COMMON_APPDATA' # rubocop:disable Metrics/BlockNesting : Any attempt to alter this breaks it
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
        windows_facts_dot_d = File.join(Dir::COMMON_APPDATA, 'PuppetLabs', 'facter', 'facts.d')
        Facter::Util::DotD.new(windows_facts_dot_d).create
      end
    end
  end
end
