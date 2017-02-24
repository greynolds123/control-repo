require 'spec_helper'

describe 'validate_ipv4_address_array' do
  it { expect { should run.with_params() }.to raise_error(/Wrong number of arguments given/) }
  it { expect { should run.with_params('1.2.3.4') }.to raise_error(/Requires an array to work with/) }
  it { expect { should run.with_params([]) }.to raise_error(/Requires an array with at least 1 element/) }
  it { should run.with_params(['1.2.3.4', '5.6.7.8']) }
end
