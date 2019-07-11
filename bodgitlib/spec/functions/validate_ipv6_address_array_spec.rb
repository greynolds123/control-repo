require 'spec_helper'

describe 'validate_ipv6_address_array' do
  it { expect { should run.with_params() }.to raise_error(/Wrong number of arguments given/) }
  it { expect { should run.with_params('dead::beef') }.to raise_error(/Requires an array to work with/) }
  it { expect { should run.with_params([]) }.to raise_error(/Requires an array with at least 1 element/) }
  it { should run.with_params(['dead::beef', 'feed::beef']) }
end
