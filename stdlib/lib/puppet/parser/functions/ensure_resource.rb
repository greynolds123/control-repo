# Test whether a given class or definition is defined
require 'puppet/parser/functions'

Puppet::Parser::Functions.newfunction(:ensure_resource,
                                      :type => :statement,
<<<<<<< HEAD
                                      :doc => <<-'DOC'
    Takes a resource type, title, and a list of attributes that describe a
    resource.

        user { 'dan':
          ensure => present,
        }

    This example only creates the resource if it does not already exist:

        ensure_resource('user', 'dan', {'ensure' => 'present' })
=======
                                      :doc => <<-DOC
  @summary
    Takes a resource type, title, and a list of attributes that describe a
    resource.

  user { 'dan':
    ensure => present,
  }

  @return
    created or recreated the passed resource with the passed type and attributes

  @example Example usage

    Creates the resource if it does not already exist:

      ensure_resource('user', 'dan', {'ensure' => 'present' })
>>>>>>> 3e0569df506721e4616112328527bfb8431b063a

    If the resource already exists but does not match the specified parameters,
    this function will attempt to recreate the resource leading to a duplicate
    resource definition error.

    An array of resources can also be passed in and each will be created with
    the type and parameters specified if it doesn't already exist.

<<<<<<< HEAD
        ensure_resource('user', ['dan','alex'], {'ensure' => 'present'})
=======
      ensure_resource('user', ['dan','alex'], {'ensure' => 'present'})
>>>>>>> 3e0569df506721e4616112328527bfb8431b063a

DOC
                                     ) do |vals|
  type, title, params = vals
  raise(ArgumentError, 'Must specify a type') unless type
  raise(ArgumentError, 'Must specify a title') unless title
  params ||= {}

  items = [title].flatten

  items.each do |item|
    Puppet::Parser::Functions.function(:defined_with_params)
    if function_defined_with_params(["#{type}[#{item}]", params])
      Puppet.debug("Resource #{type}[#{item}] with params #{params} not created because it already exists")
    else
      Puppet.debug("Create new resource #{type}[#{item}] with params #{params}")
      Puppet::Parser::Functions.function(:create_resources)
      function_create_resources([type.capitalize, { item => params }])
    end
  end
end
