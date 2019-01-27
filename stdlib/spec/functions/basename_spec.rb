require 'spec_helper'

describe 'basename' do
  it { is_expected.not_to eq(nil) }
<<<<<<< HEAD
  it { is_expected.to run.with_params().and_raise_error(Puppet::ParseError) }
=======
  it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError) }
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
  it { is_expected.to run.with_params('one', 'two', 'three').and_raise_error(Puppet::ParseError) }
  it { is_expected.to run.with_params([]).and_raise_error(Puppet::ParseError) }
  it { is_expected.to run.with_params('/path/to/a/file.ext', []).and_raise_error(Puppet::ParseError) }
  it { is_expected.to run.with_params('/path/to/a/file.ext').and_return('file.ext') }
  it { is_expected.to run.with_params('relative_path/to/a/file.ext').and_return('file.ext') }
  it { is_expected.to run.with_params('/path/to/a/file.ext', '.ext').and_return('file') }
  it { is_expected.to run.with_params('relative_path/to/a/file.ext', '.ext').and_return('file') }
  it { is_expected.to run.with_params('scheme:///path/to/a/file.ext').and_return('file.ext') }
<<<<<<< HEAD
=======

  context 'with UTF8 and double byte characters' do
    it { is_expected.to run.with_params('scheme:///√ạĺűē/竹.ext').and_return('竹.ext') }
    it { is_expected.to run.with_params('ҝẽγ:/√ạĺűē/竹.ㄘ', '.ㄘ').and_return('竹') }
  end
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
end
