# November, 2014
#
# Copyright (c) 2014-2017 Cisco and/or its affiliates.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'cisco_node_utils' if Puppet.features.cisco_node_utils?
begin
  require 'puppet_x/cisco/autogen'
rescue LoadError # seen on master, not on agent
  # See longstanding Puppet issues #4248, #7316, #14073, #14149, etc. Ugh.
  require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..',
                                     'puppet_x', 'cisco', 'autogen.rb'))
end

Puppet::Type.type(:ntp_server).provide(:cisco) do
  desc 'The Cisco provider for ntp_server.'

  confine feature: :cisco_node_utils
  defaultfor operatingsystem: :nexus

  mk_resource_methods

  NTP_SERVER_ALL_PROPS = [
    :key,
    :prefer,
    :maxpoll,
    :minpoll,
    :vrf,
  ]

  def initialize(value={})
    super(value)
    @ntpserver = Cisco::NtpServer.ntpservers[@property_hash[:name]]
    @property_flush = {}
    debug 'Created provider instance of ntp_server'
  end

  def self.properties_get(ntpserver_ip, v)
    debug "Checking instance, ntpserver #{ntpserver_ip}"

    current_state = {
      name:    ntpserver_ip,
      ensure:  :present,
      key:     v.key,
      prefer:  v.prefer.to_s,
      maxpoll: v.maxpoll,
      minpoll: v.minpoll,
      vrf:     v.vrf,
    }

    new(current_state)
  end # self.properties_get

  def self.instances
    ntpservers = []
    Cisco::NtpServer.ntpservers.each do |ntpserver_ip, v|
      ntpservers << properties_get(ntpserver_ip, v)
    end

    ntpservers
  end

  def self.prefetch(resources)
    ntpservers = instances

    resources.keys.each do |id|
      provider = ntpservers.find { |ntpserver| ntpserver.name == id }
      resources[id].provider = provider unless provider.nil?
    end
  end # self.prefetch

  def exists?
    @property_hash[:ensure] == :present
  end

  def create
    @property_flush[:ensure] = :present
  end

  def destroy
    @property_flush[:ensure] = :absent
  end

  def flush
    if @property_flush[:ensure] == :absent
      @ntpserver.destroy
      @ntpserver = nil
    else
      # Create/Update
      # NTP is a single line in the config and cannot be easily changed adhoc
      # Remove existing config and set intended state
      unless @ntpserver.nil?
        # retain previous value to rollback if set fails
        old_value = @ntpserver
        @ntpserver.destroy
      end
      # Create new instance with configured options
      opts = { 'name' => @resource[:name] }
      NTP_SERVER_ALL_PROPS.each do |prop|
        next unless @resource[prop]
        opts[prop.to_s] = @resource[prop].to_s
      end

      begin
        @ntpserver = Cisco::NtpServer.new(opts)
      rescue Cisco::CliError => e
        error "Unable to set new values: #{e.message}"
        old_value.create unless old_value.nil?
      end
    end
    # puts_config
  end
end # Puppet::Type
