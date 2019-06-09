require 'spec_helper'

describe 'validate_ldap_sub_dn' do
  it { expect { should run.with_params() }.to raise_error(/Wrong number of arguments given/) }
  it { expect { should run.with_params(123, 123) }.to raise_error(/Requires either an array or string to work with/) }
  it { expect { should run.with_params(123, [123]) }.to raise_error(/Requires either an array or string to work with/) }
  it { expect { should run.with_params('dc=example,dc=com', []) }.to raise_error(/Requires an array with at least 1 element/) }
  it { expect { should run.with_params('invalid', 'dc=example,dc=com') }.to raise_error(/is not a valid LDAP distinguished name/) }
  it { expect { should run.with_params('dc=example,dc=com', ['invalid']) }.to raise_error(/is not a valid LDAP subtree distinguished name/) }
  it { expect { should run.with_params('dc=example,dc=com', ['dc=example,dc=org']) }.to raise_error(/is not a valid LDAP subtree distinguished name/) }
  it { should run.with_params('dc=example,dc=com', 'dc=example,dc=com') }
  it { should run.with_params('dc=example,dc=com', ['ou=people,dc=example,dc=com']) }
end
