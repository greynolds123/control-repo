# Custom data_hash backend for Hiera 5 which ensures that we only see
# pe_repo parameters from the general enterprise pe.conf
# data that has been added to this module's hiera layer.
#
# Without this, Hiera will warn during every compilation for any
# parameters not in this module's namespace.
Puppet::Functions.create_function('pe_repo::data') do
  dispatch :data do
    param 'Hash', :options
    param 'Puppet::LookupContext', :context
  end

  def data(options, context)
    full_hash = call_function('hocon_data', options, context)
    full_hash.select { |k,v| k.start_with?("#{context.module_name}::") }
  end
end
