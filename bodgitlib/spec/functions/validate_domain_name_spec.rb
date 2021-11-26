require 'spec_helper'

describe 'validate_domain_name' do
  it { expect { should run.with_params() }.to raise_error(/Wrong number of arguments given/) }
  it { expect { should run.with_params(123) }.to raise_error(/Requires either an array or string to work with/) }
  it { expect { should run.with_params([123]) }.to raise_error(/Requires either an array or string to work with/) }
  it { expect { should run.with_params([]) }.to raise_error(/Requires an array with at least 1 element/) }
  it { should run.with_params(['.', 'example.com']) }
end
