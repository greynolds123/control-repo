# October, 2015
#
# Copyright (c) 2014-2016 Cisco and/or its affiliates.
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

Puppet::Type.type(:tacacs_server_group).provide(:cisco) do
  desc 'The Cisco provider for tacacs_server_group.'

  confine feature: :cisco_node_utils
  defaultfor operatingsystem: :nexus

  mk_resource_methods

  def initialize(value={})
    super(value)
    @tacacs_server_group = Cisco::TacacsServerGroup.tacacs_server_groups[@property_hash[:name]]
    @property_flush = {}
    debug 'Created provider instance of tacacs_server_group'
  end

  def self.get_properties(name, v)
    debug "Checking instance, TacacsServerGroup #{name}"

    current_state = {
      ensure:  :present,
      name:    v.name,
      servers: v.servers.empty? ? ['unset'] : v.servers,
    }

    new(current_state)
  end # self.get_properties

  def self.instances
    tacacs_server_groups = []
    Cisco::TacacsServerGroup.tacacs_server_groups.each do |name, v|
      tacacs_server_groups << get_properties(name, v)
    end

    tacacs_server_groups
  end

  def self.prefetch(resources)
    tacacs_server_groups = instances

    resources.keys.each do |id|
      provider = tacacs_server_groups.find { |instance| instance.name == id }
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

  def munge_values(val)
    if val.is_a?(Array) && val.length == 1 && val[0].eql?('unset')
      []
    else
      val
    end
  end

  def flush
    if @property_flush[:ensure] == :absent
      @tacacs_server_group.destroy
      @tacacs_server_group = nil
      @property_hash[:ensure] = :absent
    else

      if @property_hash.empty?
        # create a new Tacacs Server Group
        @tacacs_server_group = Cisco::TacacsServerGroup.new(@resource[:name])
      end

      # Handle servers setting
      @tacacs_server_group.servers = munge_values(@resource[:servers]) if @resource[:servers]
    end
  end
end   # Puppet::Type
