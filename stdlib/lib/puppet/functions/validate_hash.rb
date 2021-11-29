<<<<<<< HEAD
Puppet::Functions.create_function(:validate_hash) do
=======
# @summary
#   Validate the passed value represents a hash.
Puppet::Functions.create_function(:validate_hash) do
  # @param scope
  #   The main value that will be passed to the method
  #
  # @param args
  #   Any additional values that are to be passed to the method
  #
  # @return
  #   A boolean value (`true` or `false`) returned from the called function.
>>>>>>> 3e0569df506721e4616112328527bfb8431b063a
  dispatch :deprecation_gen do
    param 'Any', :scope
    repeated_param 'Any', :args
  end
  # Workaround PUP-4438 (fixed: https://github.com/puppetlabs/puppet/commit/e01c4dc924cd963ff6630008a5200fc6a2023b08#diff
  #   -c937cc584953271bb3d3b3c2cb141790R221) to support puppet < 4.1.0 and puppet < 3.8.1.
  def call(scope, *args)
    manipulated_args = [scope] + args
    self.class.dispatcher.dispatch(self, scope, manipulated_args)
  end

  def deprecation_gen(scope, *args)
    call_function('deprecation', 'validate_hash', 'This method is deprecated, please use the stdlib validate_legacy function,
                    with Stdlib::Compat::Hash. There is further documentation for validate_legacy function in the README.')
    scope.send('function_validate_hash', args)
  end
end
