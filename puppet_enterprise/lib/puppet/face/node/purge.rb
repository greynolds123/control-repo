Puppet::Face.define(:node, '0.0.1') do

  action(:purge) do

    summary "Deactivate nodes in PuppetDB and purge information from the master"
    arguments "<node> [<node> ...]"
    description <<-DESC
      Calls "puppet node deactivate" and "puppet node clean" on the provided
      node(s). This will deactivate a node in PuppetDB and then purge that
      node's information, including certificates, from the master.
      DESC

    when_invoked do |*args|

      opts = args.pop
      nodes = args
      raise ArgumentError, "Please provide at least one node" if nodes.empty?

      # The deactivate action should only be available on master nodes as it is
      # included in the puppetdb-terminus package.
      if Puppet::Interface.find_action(:node, :deactivate, :current)

        Puppet::Face[:node, :current].deactivate(*nodes)

        Puppet::Face[:node, :current].clean(*nodes)

      else
        raise "This command cannot be run on an agent node. Please try again on a master node."
      end
    end

    when_rendering(:console) do |node_list|
      if node_list.length == 1
        purged_msg = %Q|Node "#{node_list[0]}" was purged.|
      else
        purged_msg = %Q|Nodes #{node_list} were purged.|
      end

      <<-MSG
#{purged_msg}

To ensure this node can not check into any additional compile masters, run puppet on all compile masters.

- If you plan to re-add a node to your Puppet infrastructure:
   1. Clear the agent certificate from the node.
      On *nix, run `rm -rf /etc/puppetlabs/puppet/ssl`.
      On Windows, delete the `$confdir\\ssl` directory.
   2. On the agent node, run Puppet.
        MSG
    end
  end
end
