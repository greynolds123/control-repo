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
      <<-MSG
Node "#{node_list[0]}" was purged. If you want to add this node back to your
 Puppet infrastructure, remove old certificates from the agent node first.
        MSG

      else
      <<-MSG
Nodes #{node_list} were purged. If you want to add these nodes back to your
 Puppet infrastructure, remove the old certificates from the agent node first.
        MSG
      end
    end
  end
end
