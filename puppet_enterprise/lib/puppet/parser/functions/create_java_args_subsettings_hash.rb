module Puppet::Parser::Functions
  newfunction(:create_java_args_subsettings_hash, :type => :rvalue) do |args|
    service_name   = args[0]
    java_args_hash = args[1]
    params_hash    = args[2]
    resource_hash  = {}

    java_args_hash.each { |java_arg,value|
      subsetting_hash = {
          'ensure'            => 'present',
          'key_val_separator' => '=',
          'section'           => '',
          'setting'           => 'JAVA_ARGS',
          'subsetting'        => "-#{java_arg}",
          'quote_char'        => '"',
          'value'             => (value || '')
      }
      subsetting_hash.merge!(params_hash)
      resource_hash.merge!({ "#{service_name}_'#{java_arg}'" => subsetting_hash })
    }

    resource_hash
  end
end
