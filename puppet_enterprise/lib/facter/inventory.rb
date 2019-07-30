require 'puppet'

class Packages

  attr_accessor :last_collection_time

  def initialize
    @last_collection_time = nil
  end

  def gather_inventory
    start_time = Time.now
    packages = []

    string_sanitizer = if String.instance_methods.include?(:scrub)
                         # Replace byte sequences that do not compose
                         # to valid UTF8, and null bytes with the Unicode
                         # Replacement Character: "�"
                         proc {|s| s.scrub.gsub("\0", "\uFFFD") }
                       else
                         # Ruby 2.0 or older (PE 3.x) , or JRuby 1.7.
                         # Best we can do is scrub null bytes.
                         proc {|s| s.gsub("\0", "\uFFFD") }
                       end

    Puppet::Type.type(:package).providers_by_source.each do |provider|
      begin
        provider.instances.each do |resource_instance|
          properties = resource_instance.properties
          resource_versions = [properties[:ensure]].flatten # ensure can be an array or string
          resource_versions.each do |version|
            packages << [string_sanitizer.call(properties[:name].to_s),
                         string_sanitizer.call(version.to_s),
                         properties[:provider].to_s]
          end
        end
      rescue => detail
        Puppet.log_exception(detail, "Cannot collect packages for #{provider} provider; #{detail}")
      end
    end

    @last_collection_time = Time.now - start_time
    packages
  end

  def enabled?
    enabled_file = '/opt/puppetlabs/puppet/cache/state/package_inventory_enabled'
    if Facter.value('operatingsystem') == 'windows'
      enabled_file = File.join(Facter.value('common_appdata'),
                               'PuppetLabs/puppet/cache/state/package_inventory_enabled')
    end
    File.exists?(enabled_file)
  end
end

module Inventory
  def self.add_inventory(packages)
    Facter.add(:_puppet_inventory_1) do
      confine do
        packages.enabled?
      end

      setcode do
        { 'packages' => packages.gather_inventory }
      end
    end
  end

  def self.add_metadata(packages)
    Facter.add(:puppet_inventory_metadata) do
      setcode do
        # Do this check here to force resolution of the actual inventory
        unless Facter.value('_puppet_inventory_1')
          packages.last_collection_time = 0.0
        end

        { 'packages' => { 'collection_enabled' => packages.enabled?,
                          'last_collection_time' => "#{packages.last_collection_time.round(4)}s" }}
      end
    end
  end

  def self.add_facts
    packages = Packages.new
    Inventory.add_inventory(packages)
    Inventory.add_metadata(packages)
  end
end

Inventory.add_facts
