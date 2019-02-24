$puppet_application_name = :agent
require 'puppet'

module MCollective
  module Agent
    # An agent that uses the Puppet resource abstraction layer (RAL) to
    # perform finding and searching of resources.
    #
    # To use this you can make requests like:
    #
    #   mco rpc puppetral find type=user name=foo
    #
    # ...which will find a user foo.
    #
    # To search a resource type, make a request like:
    #
    #   mco rpc puppetral search type=user
    #
    # ...which will return a list of all user resources.
    class Puppetral<RPC::Agent

      # Before returning resources we will prune the parameters
      # so only properties remain, but certain types should have some of their
      # parameters retained (mostly, packages need provider info)
      def retain_params(resource)
        provider = resource[:provider] if resource.type.downcase == 'package'
        result = resource.respond_to?(:prune_parameters) ?
          resource.prune_parameters.to_data_hash : resource.to_data_hash
        result['parameters'][:provider] = provider if provider

        # round-trip via json to smash all the parameters to their
        # simplest representations
        JSON.load(result.to_json)
      end

      action "find" do
        type = request[:type]
        title = request[:title]
        typeobj = ::Puppet::Type.type(type) or reply.fail!(reply[:type] = "Could not find type #{type}")

        if typeobj
          resource = ::Puppet::Resource.indirection.find([type, title].join('/'))
          retain_params(resource).each { |k,v| reply[k.to_sym] = v }

          begin
            managed_resources = File.readlines(::Puppet[:resourcefile])
            managed_resources = managed_resources.map{|r|r.chomp}
            reply[:managed] = managed_resources.include?("#{type}[#{title}]")
          rescue
            reply[:managed] = "unknown"
          end
        end
      end

      action "search" do
        type = request[:type]
        typeobj = ::Puppet::Type.type(type) or reply.fail!(reply[:result] = "Could not find type #{type}")

        if typeobj
          result = ::Puppet::Resource.indirection.search(type, {}).map do |r|
            retain_params(r)
          end

          reply[:result] = result
        end
      end
    end
  end
end
