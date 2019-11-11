require 'xmlrpc/client'
require 'fileutils'

Puppet::Type.type(:cobbler_system).provide(:ruby) do
  desc "Provides cobbler system via cobbler_api"

  # Supports redhat only
  confine    :osfamily => :redhat
  defaultfor :osfamily => :redhat
  commands   :cobbler  => 'cobbler'

  mk_resource_methods
  # generates the following methods via Ruby metaprogramming
  # def version
  #   @property_hash[:version] || :absent
  # end

  # Resources discovery
  def self.instances
    systems = []
    cserver = XMLRPC::Client.new2('http://127.0.0.1/cobbler_api')
    xmlresult = cserver.call('get_systems')
    # get properties of current system to @property_hash
    xmlresult.each do |system|
      systems << new(
        :name                     => system["name"],
        :ensure                   => :present,
        :profile                  => system["profile"],
        :hostname                 => system["hostname"],
        :interfaces               => system["interfaces"],
        :redhat_management_server => system["redhat_management_server"],
        :redhat_management_key    => system["redhat_management_key"],
        :server                   => system["server"],
        :netboot_enabled          => system["netboot_enabled"].to_s
      )
    end
    systems
  end

  def self.prefetch(resources)
    instances.each do |system|
      if resource = resources[system.name]
        resource.provider = system
      end
    end
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def create
    # To add a system only name and profile is required
    cobbler(
            [
              "system",
              "add",
              "--name=" + @resource[:name],
              "--profile=" + @resource[:profile]
            ]
           )
    # set properties as they are not set by defaut
    properties = [
      "hostname",
      "redhat_management_server",
      "redhat_management_key",
      "server",
    ]
    for property in properties
      unless self.send(property) == @resource.should(property) or @resource[property].nil?
        self.set_field(property, @resource.should(property))
      end
    end

    unless self.interfaces == @resource.should(:interfaces) or @resource[:interfaces].nil?
      self.interfaces = @resource.should(:interfaces)
    end

    cobbler("sync")
    @property_hash[:ensure] = :present
  end

  def set_field(what, value)
    if value.is_a? Array
      value = "#{value.join(' ')}"
    end

    cobbler(
      [
        "system",
        "edit",
        "--name=" + @resource[:name],
        "--#{what.tr('_','-')}=" + value.to_s
      ]
    )
    cobbler('sync')
    @property_hash[what] = value
  end

  def destroy
    # remove cobbler system
    cobbler(
      [
        "system",
        "remove",
        "--name=#{@resource[:name]}"
      ]
    )
    @property_hash.clear
  end

  # Setters
  def hostname=(value)
    self.set_field("hostname", value)
  end

  def server=(value)
    self.set_field("server", value)
  end

  def profile=(value)
    self.set_field("profile", value)
  end

  def gateway=(value)
    self.set_field("gateway", value)
  end

  def redhat_management_server=(value)
    self.set_field("redhat_management_server", value)
  end

  def redhat_management_key=(value)
    self.set_field("redhat_management_key", value)
  end

  def netboot_enabled=(value)
    self.set_field("netboot_enabled", value)
  end

  def interfaces=(value)
    value.each do |interface,params|
      cmd_args = []
      cmd_args << "system edit --name=#{@resource[:name]} --interface=#{interface}".split(' ')
      params.each do |param,val|
        cmd_args << "--#{param.tr('_','-')}=#{val.to_s}"
      end
      cobbler(cmd_args)
    end
    cobbler('sync')
  end

end
