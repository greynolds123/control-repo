require 'spec_helper'

describe 'dirname' do
  it { is_expected.not_to eq(nil) }
<<<<<<< HEAD
  it { is_expected.to run.with_params().and_raise_error(Puppet::ParseError) }
=======
  it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError) }
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
  it { is_expected.to run.with_params('one', 'two').and_raise_error(Puppet::ParseError) }
  it { is_expected.to run.with_params([]).and_raise_error(Puppet::ParseError) }
  it { is_expected.to run.with_params({}).and_raise_error(Puppet::ParseError) }
  it { is_expected.to run.with_params(1).and_raise_error(Puppet::ParseError) }
  it { is_expected.to run.with_params('/path/to/a/file.ext', []).and_raise_error(Puppet::ParseError) }
  it { is_expected.to run.with_params('/path/to/a/file.ext').and_return('/path/to/a') }
  it { is_expected.to run.with_params('relative_path/to/a/file.ext').and_return('relative_path/to/a') }
<<<<<<< HEAD
=======

  context 'with UTF8 and double byte characters' do
    it { is_expected.to run.with_params('scheme:///√ạĺűē/竹.ext').and_return('scheme:///√ạĺűē') }
    it { is_expected.to run.with_params('ҝẽγ:/√ạĺűē/竹.ㄘ').and_return('ҝẽγ:/√ạĺűē') }
  end
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
end
