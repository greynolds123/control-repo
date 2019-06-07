require 'spec_helper'

describe 'validate_ldap_filter' do
  it { expect { should run.with_params() }.to raise_error(/Wrong number of arguments given/) }
  it { expect { should run.with_params(123) }.to raise_error(/Requires either an array or string to work with/) }
  it { expect { should run.with_params([123]) }.to raise_error(/Requires either an array or string to work with/) }
  it { expect { should run.with_params([]) }.to raise_error(/Requires an array with at least 1 element/) }
  it { expect { should run.with_params('invalid') }.to raise_error(/is not a valid LDAP filter/) }
  it { expect { should run.with_params(['invalid']) }.to raise_error(/is not a valid LDAP filter/) }
  # Taken from the RFC 2254 examples
  it { should run.with_params('(cn=Babs Jensen)') }
  it { should run.with_params('(!(cn=Tim Howes))') }
  it { should run.with_params('(&(objectClass=Person)(|(sn=Jensen)(cn=Babs J*)))') }
  it { should run.with_params('(o=univ*of*mich*)') }
  it { should run.with_params('(cn:1.2.3.4.5:=Fred Flintstone)') }
  it { should run.with_params('(sn:dn:2.4.6.8.10:=Barney Rubble)') }
  it { should run.with_params('(o:dn:=Ace Industry)') }
  it { should run.with_params('(:dn:2.4.6.8.10:=Dino)') }
  it { should run.with_params('(o=Parens R Us \28for all your parenthetical needs\29)') }
  it { should run.with_params('(cn=*\2A*)') }
  it { should run.with_params('(filename=C:\5cMyFile)') }
  it { should run.with_params('(bin=\00\00\00\04)') }
  it { should run.with_params('(sn=Lu\c4\8di\c4\87)') }
  it {
    should run.with_params([
      '(cn=Babs Jensen)',
      '(!(cn=Tim Howes))',
      '(&(objectClass=Person)(|(sn=Jensen)(cn=Babs J*)))',
      '(o=univ*of*mich*)',
      '(cn:1.2.3.4.5:=Fred Flintstone)',
      '(sn:dn:2.4.6.8.10:=Barney Rubble)',
      '(o:dn:=Ace Industry)',
      '(:dn:2.4.6.8.10:=Dino)',
      '(o=Parens R Us \28for all your parenthetical needs\29)',
      '(cn=*\2A*)',
      '(filename=C:\5cMyFile)',
      '(bin=\00\00\00\04)',
      '(sn=Lu\c4\8di\c4\87)',
    ])
  }
end
