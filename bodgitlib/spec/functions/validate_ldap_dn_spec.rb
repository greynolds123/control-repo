require 'spec_helper'

describe 'validate_ldap_dn' do
  it { expect { should run.with_params() }.to raise_error(/Wrong number of arguments given/) }
  it { expect { should run.with_params(123) }.to raise_error(/Requires either an array or string to work with/) }
  it { expect { should run.with_params([123]) }.to raise_error(/Requires either an array or string to work with/) }
  it { expect { should run.with_params([]) }.to raise_error(/Requires an array with at least 1 element/) }
  it { expect { should run.with_params('invalid') }.to raise_error(/is not a valid LDAP distinguished name/) }
  it { expect { should run.with_params(['invalid']) }.to raise_error(/is not a valid LDAP distinguished name/) }
  # Taken from the RFC 2253 examples
  it { should run.with_params('CN=Steve Kille,O=Isode Limited,C=GB') }
  it { should run.with_params('OU=Sales+CN=J. Smith,O=Widget Inc.,C=US') }
  it { should run.with_params('CN=L. Eagle,O=Sue\, Grabbit and Runn,C=GB') }
  it { should run.with_params('CN=Before\0DAfter,O=Test,C=GB') }
  it { should run.with_params('1.3.6.1.4.1.1466.0=#04024869,O=Test,C=GB') }
  it {
    should run.with_params([
      'CN=Steve Kille,O=Isode Limited,C=GB',
      'OU=Sales+CN=J. Smith,O=Widget Inc.,C=US',
      'CN=L. Eagle,O=Sue\, Grabbit and Runn,C=GB',
      'CN=Before\0DAfter,O=Test,C=GB',
      '1.3.6.1.4.1.1466.0=#04024869,O=Test,C=GB',
    ])
  }
end
