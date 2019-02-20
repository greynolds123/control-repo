module Puppet::Parser::Functions
  newfunction(:pe_puppetserver_static_content_list, :type => :rvalue, :doc => <<-EOS
This function takes a hash provided by
`puppet_enterprise::master::puppetserver.static_files and produces a string that
is a hocon list of static files that can be consumed by the webserver.conf
configuration file.

*Examples:*

    pe_puppetserver_static_content_list({'key'=>'value', 'one'=>'two'})

Would result in: "[
  {resource: "value", path: "key", follow-links: true}
  {resource: "two", path: "one", follow-links: true}
]"
    EOS
  ) do |arguments|

    # Validate the number of arguments
    if arguments.size != 1
      raise(Puppet::ParseError, "pe_puppetserver_static_content_list(): Takes exactly " +
           "one argument, but #{arguments.size} given.")
    end

    # Validate the first argument.
    hash = arguments[0]
    if not hash.is_a?(Hash)
      raise(TypeError, "pe_puppetserver_static_content_list(): The argument given must " +
            "be a hash, but a #{hash.class} was given.")
    end

    hashes = hash.map do |k, v|
      if not k.is_a?(String)
        raise(TyperError, "pe_puppetserver_static_content_list(): All keys in hash must " +
              "be a string, but key #{k.to_s} is type #{k.class}")
      end
      if not v.is_a?(String)
        raise(TyperError, "pe_puppetserver_static_content_list(): All keys in hash must " +
              "be a string, but key #{v.to_s} is type #{v.class}")
      end
      {"resource" => "#{v}", "path" => "#{k}", "follow-links" => true}
    end
    hashes
  end
end
