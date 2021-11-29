<<<<<<< HEAD
# A Facter plugin that loads facts from /etc/facter/facts.d
# and /etc/puppetlabs/facter/facts.d.
=======
# @summary
#   A Facter plugin that loads facts from /etc/facter/facts.d
#   and /etc/puppetlabs/facter/facts.d.
>>>>>>> 3e0569df506721e4616112328527bfb8431b063a
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
class Facter::Util::DotD
  require 'yaml'
<<<<<<< HEAD

=======
  # These will be nil if Puppet is not available.
>>>>>>> 3e0569df506721e4616112328527bfb8431b063a
  def initialize(dir = '/etc/facts.d', cache_file = File.join(Puppet[:libdir], 'facts_dot_d.cache'))
    @dir = dir
    @cache_file = cache_file
    @cache = nil
    @types = { '.txt' => :txt, '.json' => :json, '.yaml' => :yaml }
  end

<<<<<<< HEAD
=======
  # entries
>>>>>>> 3e0569df506721e4616112328527bfb8431b063a
  def entries
    Dir.entries(@dir).reject { |f| f =~ %r{^\.|\.ttl$} }.sort.map { |f| File.join(@dir, f) }
  rescue
    []
  end

<<<<<<< HEAD
=======
  # fact_type
  # @param file
>>>>>>> 3e0569df506721e4616112328527bfb8431b063a
  def fact_type(file)
    extension = File.extname(file)

    type = @types[extension] || :unknown

    type = :script if type == :unknown && File.executable?(file)

    type
  end

<<<<<<< HEAD
=======
  # txt_parser
  # @param file
>>>>>>> 3e0569df506721e4616112328527bfb8431b063a
  def txt_parser(file)
    File.readlines(file).each do |line|
      next unless line =~ %r{^([^=]+)=(.+)$}
      var = Regexp.last_match(1)
      val = Regexp.last_match(2)

      Facter.add(var) do
        setcode { val }
      end
    end
  rescue StandardError => e
    Facter.warn("Failed to handle #{file} as text facts: #{e.class}: #{e}")
  end

<<<<<<< HEAD
=======
  # json_parser
  # @param file
>>>>>>> 3e0569df506721e4616112328527bfb8431b063a
  def json_parser(file)
    begin
      require 'json'
    rescue LoadError
      retry if require 'rubygems'
      raise
    end

    JSON.parse(File.read(file)).each_pair do |f, v|
      Facter.add(f) do
        setcode { v }
      end
    end
  rescue StandardError => e
    Facter.warn("Failed to handle #{file} as json facts: #{e.class}: #{e}")
  end

<<<<<<< HEAD
=======
  # yaml_parser
  # @param file
>>>>>>> 3e0569df506721e4616112328527bfb8431b063a
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

<<<<<<< HEAD
=======
  # script_parser
  # @param file
>>>>>>> 3e0569df506721e4616112328527bfb8431b063a
  def script_parser(file)
    result = cache_lookup(file)
    ttl = cache_time(file)

    if result
      Facter.debug("Using cached data for #{file}")
    else
      result = Facter::Util::Resolution.exec(file)

      if ttl > 0
        Facter.debug("Updating cache for #{file}")
        cache_store(file, result)
        cache_save!
      end
    end

    result.split("\n").each do |line|
      next unless line =~ %r{^(.+)=(.+)$}
      var = Regexp.last_match(1)
      val = Regexp.last_match(2)

      Facter.add(var) do
        setcode { val }
      end
    end
  rescue StandardError => e
    Facter.warn("Failed to handle #{file} as script facts: #{e.class}: #{e}")
    Facter.debug(e.backtrace.join("\n\t"))
  end

<<<<<<< HEAD
=======
  # cache_save
>>>>>>> 3e0569df506721e4616112328527bfb8431b063a
  def cache_save!
    cache = load_cache
    File.open(@cache_file, 'w', 0o600) { |f| f.write(YAML.dump(cache)) }
  rescue # rubocop:disable Lint/HandleExceptions
  end

<<<<<<< HEAD
=======
  # cache_store
  # @param file
>>>>>>> 3e0569df506721e4616112328527bfb8431b063a
  def cache_store(file, data)
    load_cache

    @cache[file] = { :data => data, :stored => Time.now.to_i }
  rescue # rubocop:disable Lint/HandleExceptions
  end

<<<<<<< HEAD
=======
  # cache_lookup
  # @param file
>>>>>>> 3e0569df506721e4616112328527bfb8431b063a
  def cache_lookup(file)
    cache = load_cache

    return nil if cache.empty?

    ttl = cache_time(file)

    return nil unless cache[file]
    now = Time.now.to_i

    return cache[file][:data] if ttl == -1
    return cache[file][:data] if (now - cache[file][:stored]) <= ttl
    return nil
  rescue
    return nil
  end

<<<<<<< HEAD
=======
  # cache_time
  # @param file
>>>>>>> 3e0569df506721e4616112328527bfb8431b063a
  def cache_time(file)
    meta = file + '.ttl'

    return File.read(meta).chomp.to_i
  rescue
    return 0
  end

<<<<<<< HEAD
=======
  # load_cache
>>>>>>> 3e0569df506721e4616112328527bfb8431b063a
  def load_cache
    @cache ||= if File.exist?(@cache_file)
                 YAML.load_file(@cache_file)
               else
                 {}
               end

    return @cache
  rescue
    @cache = {}
    return @cache
  end

<<<<<<< HEAD
=======
  # create
>>>>>>> 3e0569df506721e4616112328527bfb8431b063a
  def create
    entries.each do |fact|
      type = fact_type(fact)
      parser = "#{type}_parser"

      next unless respond_to?("#{type}_parser")
      Facter.debug("Parsing #{fact} using #{parser}")

      send(parser, fact)
    end
  end
end

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
        windows_facts_dot_d = File.join(Dir::COMMON_APPDATA, 'PuppetLabs', 'facter', 'facts.d')
        Facter::Util::DotD.new(windows_facts_dot_d).create
      end
    end
  end
end
