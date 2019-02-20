require 'spec_helper'

describe 'validate_ldap_uri' do
  it { expect { should run.with_params() }.to raise_error(/Wrong number of arguments given/) }
  it { expect { should run.with_params(123) }.to raise_error(/Requires either an array or string to work with/) }
  it { expect { should run.with_params([123]) }.to raise_error(/Requires either an array or string to work with/) }
  it { expect { should run.with_params([]) }.to raise_error(/Requires an array with at least 1 element/) }
  it { expect { should run.with_params('invalid') }.to raise_error(/is not a valid LDAP URI/) }
  it { expect { should run.with_params(['invalid']) }.to raise_error(/is not a valid LDAP URI/) }
  it { expect { should run.with_params('http://example.com/') }.to raise_error(/is not a valid LDAP URI/) }
  it { should run.with_params('ldap://example.com') }
  it { should run.with_params('ldaps://example.com') }
  it { should run.with_params('ldapi://%2fexample%2fcom') }
  it {
    should run.with_params([
      'ldap://example.com',
      'ldaps://example.com',
      'ldapi://%2fexample%2fcom',
    ])
  }
  it { should run.with_params('ldap:///') }
  it { expect { should run.with_params('ldap:///invalid') }.to raise_error(/is not a valid LDAP URI/) }
  it { expect { should run.with_params('ldap:///dc=example,dc=com?uidNumber?invalid') }.to raise_error(/is not a valid LDAP URI/) }
  it { expect { should run.with_params('ldap:///dc=example,dc=com?uidNumber?sub?invalid') }.to raise_error(/is not a valid LDAP URI/) }
  it { should run.with_params('ldap:///dc=example,dc=com?uidNumber?sub?(sn=e*)') }
end
