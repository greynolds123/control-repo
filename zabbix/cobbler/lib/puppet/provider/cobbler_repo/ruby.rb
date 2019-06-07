require 'xmlrpc/client'
require 'fileutils'

Puppet::Type.type(:cobbler_repo).provide(:ruby) do
  desc "Provides cobbler repo via cobbler_api"

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
    repos = []
    cserver = XMLRPC::Client.new2('http://127.0.0.1/cobbler_api')
    xmlresult = cserver.call('get_repos')
    # get properties of current repo to @property_hash
    xmlresult.each do |repo|
      repos << new(
        :name           => repo["name"],
        :ensure         => :present,
        :arch           => repo["arch"],
        :breed          => repo["breed"],
        :mirror         => repo["mirror"],
        :mirror_locally => repo["mirror_locally"].to_s,
        :rpmlist        => repo["rpmlist"],
      )
    end
    repos
  end

  def self.prefetch(resources)
    instances.each do |repo|
      if resource = resources[repo.name]
        resource.provider = repo
      end
    end
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def reposync
    if @resource[:reposync]
      cobbler([
        "reposync",
        "--only=" + @resource[:name]
    ])
    end
  end

  def create
    # To add a profile only name and distro is required
    cobbler(
            [
              "repo",
              "add",
              "--name=" + @resource[:name],
              "--mirror=" + @resource[:mirror]
            ]
           )
    # set properties as they are not set by defaut
    properties = [
      "arch",
      "breed",
      "mirror_locally",
      "rpmlist"
    ]
    for property in properties
      unless self.send(property) == @resource.should(property) or @resource[property].nil?
        self.set_field(property, @resource.should(property))
      end
    end

    cobbler("sync")
    self.reposync
    @property_hash[:ensure] = :present
  end

  def set_field(what, value)
    if value.is_a? Array
      value = "#{value.join(' ')}"
    end

    cobbler(
      [
        "repo",
        "edit",
        "--name=" + @resource[:name],
        "--#{what.tr('_','-')}=" + value.to_s
      ]
    )
    cobbler('sync')
    @property_hash[what] = value
  end

  def destroy
    # remove cobbler repo
    cobbler(
      [
        "repo",
        "remove",
        "--name=#{@resource[:name]}"
      ]
    )
    @property_hash.clear
  end

  # Getters

  def rpmlist
    @property_hash[:rpmlist] || []
  end

  # Setters
  def arch=(value)
    self.set_field("arch", value)
  end

  def breed=(value)
    self.set_field("breed", value)
  end

  def mirror=(value)
    self.set_field("mirror", value)
  end

  def mirror_locally=(value)
    self.set_field("mirror_locally", value)
  end

  def rpmlist=(value)
    self.set_field("rpmlist", value)
  end

end
