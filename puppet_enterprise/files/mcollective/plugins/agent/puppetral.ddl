metadata    :name        => "puppetral",
            :description => "View resources with Puppet's resource abstraction layer",
            :author      => "R.I.Pienaar, Max Martin",
            :license     => "ASL2",
            :version     => "1.0",
            :url         => "http://docs.puppetlabs.com/pe/latest/console_live_resources.html",
            :timeout     => 180

action "find", :description => "Get the attributes and status of a resource" do
    display :always

    input :type,
          :prompt      => "Resource type",
          :description => "Type of resource to check",
          :type        => :string,
          :validation  => '.',
          :optional    => false,
          :maxlength   => 90

    input :title,
          :prompt      => "Resource title",
          :description => "Name of resource to check",
          :type        => :string,
          :validation  => '.',
          :optional    => false,
          :maxlength   => 90

    output :type,
          :description => "Type of the inspected resource",
          :display_as  => "Type"

    output :title,
          :description => "Title of the inspected resource",
          :display_as  => "Title"

    output :tags,
          :description => "Tags of the inspected resource",
          :display_as  => "Tags"

    output :exported,
          :description => "Boolean flag indicating export status",
          :display_as  => "Exported"

    output :parameters,
          :description => "Parameters of the inspected resource",
          :display_as  => "Parameters"

    output :managed,
          :description => "Flag indicating managed status",
          :display_as  => "Managed"
end

action "search", :description => "Get detailed info for all resources of a given type" do
    display :always

    input :type,
          :prompt      => "Resource type",
          :description => "Type of resource to check",
          :type        => :string,
          :validation  => '.',
          :optional    => false,
          :maxlength   => 90

    output :result,
           :description => "The values of the inspected resources",
           :display_as  => "Result"
end
