require 'spec_helper'

describe 'downcase' do
  it { is_expected.not_to eq(nil) }
<<<<<<< HEAD
  it { is_expected.to run.with_params().and_raise_error(Puppet::ParseError) }
  it { is_expected.to run.with_params(100).and_raise_error(Puppet::ParseError) }
  it { is_expected.to run.with_params("abc").and_return("abc") }
  it { is_expected.to run.with_params("Abc").and_return("abc") }
  it { is_expected.to run.with_params("ABC").and_return("abc") }

  it { is_expected.to run.with_params(AlsoString.new("ABC")).and_return("abc") }
  it { is_expected.to run.with_params([]).and_return([]) }
  it { is_expected.to run.with_params(["ONE", "TWO"]).and_return(["one", "two"]) }
  it { is_expected.to run.with_params(["One", 1, "Two"]).and_return(["one", 1, "two"]) }
=======
  it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError) }
  it { is_expected.to run.with_params(100).and_raise_error(Puppet::ParseError) }
  it { is_expected.to run.with_params('abc').and_return('abc') }
  it { is_expected.to run.with_params('Abc').and_return('abc') }
  it { is_expected.to run.with_params('ABC').and_return('abc') }

  it { is_expected.to run.with_params(AlsoString.new('ABC')).and_return('abc') }
  it { is_expected.to run.with_params([]).and_return([]) }
  it { is_expected.to run.with_params(%w[ONE TWO]).and_return(%w[one two]) }
  it { is_expected.to run.with_params(['One', 1, 'Two']).and_return(['one', 1, 'two']) }
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
end
