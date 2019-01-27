require 'spec_helper'

describe 'pick' do
  it { is_expected.not_to eq(nil) }
<<<<<<< HEAD
  it { is_expected.to run.with_params().and_raise_error(Puppet::ParseError, /must receive at least one non empty value/) }
  it { is_expected.to run.with_params('', nil, :undef, :undefined).and_raise_error(Puppet::ParseError, /must receive at least one non empty value/) }
=======
  it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError, %r{must receive at least one non empty value}) }
  it { is_expected.to run.with_params('', nil, :undef, :undefined).and_raise_error(Puppet::ParseError, %r{must receive at least one non empty value}) }
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
  it { is_expected.to run.with_params('one', 'two').and_return('one') }
  it { is_expected.to run.with_params('', 'two').and_return('two') }
  it { is_expected.to run.with_params(:undef, 'two').and_return('two') }
  it { is_expected.to run.with_params(:undefined, 'two').and_return('two') }
  it { is_expected.to run.with_params(nil, 'two').and_return('two') }
<<<<<<< HEAD
=======

  context 'with UTF8 and double byte characters' do
    it { is_expected.to run.with_params(nil, 'このテキスト').and_return('このテキスト') }
    it { is_expected.to run.with_params('', 'ŝẳмрłề џţƒ8 ţẽ×ť', 'このテキスト').and_return('ŝẳмрłề џţƒ8 ţẽ×ť') }
  end
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
end
