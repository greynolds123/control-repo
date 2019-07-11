# optional, this should be the path to where the hiera data config file is in this repo
# You must update this if your actual hiera data lives inside your module.
# I only assume you have a separate repository for hieradata and its include in your .fixtures
hiera_config_file = File.expand_path(File.join(File.dirname(__FILE__), 'fixtures','modules','hieradata', 'hiera.yaml'))

# hiera_config and hiera_data are mutually exclusive contexts.

shared_context :global_hiera_data do
  let(:hiera_data) do
     {
       #"quagga::bgpd::conf_file" => '',
       #"quagga::bgpd::enable_advertisements" => '',
       #"quagga::bgpd::enable_advertisements_v4" => '',
       #"quagga::bgpd::enable_advertisements_v6" => '',
       #"quagga::bgpd::failover_server" => '',
       "quagga::bgpd::failsafe_networks4" => ['192.0.2.0/25'],
       "quagga::bgpd::failsafe_networks6" => ['2001:DB8::/32'],
       #"quagga::bgpd::manage_nagios" => true,
       "quagga::bgpd::my_asn" => [64496],
       "quagga::bgpd::networks4" => ['192.0.2.0/25'],
       "quagga::bgpd::networks6" => ['2001:DB8::/48'],
       "quagga::bgpd::peers" => {
            "64497" => {
                "addr4"          => ["192.0.2.2"],
                "addr6"          => ["2001:DB8::2"],
                "desc"           => "TEST Network",
                "inbound_routes" => "all",
                "community"      => ["no-export", "64497:100" ],
                "localpref"       => 100,
                "multihop"       => 5,
                "password"       => "password",
                "prepend"        => 3,
          },
       },
       "quagga::bgpd::router_id" => '192.0.2.1',
       #"quagga::content" => '',
       #"quagga::enable_zebra" => '',
       #"quagga::group" => '',
       #"quagga::mode" => '',
       #"quagga::owner" => '',
       #"quagga::package" => '',
     
     }
  end
end

shared_context :hiera do
    # example only,
    let(:hiera_data) do
        {:some_key => "some_value" }
    end
end

shared_context :linux_hiera do
    # example only,
    let(:hiera_data) do
        {:some_key => "some_value" }
    end
end

# In case you want a more specific set of mocked hiera data for windows
shared_context :windows_hiera do
    # example only,
    let(:hiera_data) do
        {:some_key => "some_value" }
    end
end

# you cannot use this in addition to any of the hiera_data contexts above
shared_context :real_hiera_data do
    let(:hiera_config) do
       hiera_config_file
    end
end
