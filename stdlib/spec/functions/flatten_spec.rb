require 'spec_helper'

describe 'flatten', :if => Puppet::Util::Package.versioncmp(Puppet.version, '5.5.0') < 0 do
  it { is_expected.not_to eq(nil) }
<<<<<<< HEAD
  it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError) }
  it { is_expected.to run.with_params([], []).and_raise_error(Puppet::ParseError) }
  it { is_expected.to run.with_params(1).and_raise_error(Puppet::ParseError) }
  it { is_expected.to run.with_params('one').and_raise_error(Puppet::ParseError) }
  it { is_expected.to run.with_params([]).and_return([]) }
  it { is_expected.to run.with_params(['one']).and_return(['one']) }
  it { is_expected.to run.with_params([['one']]).and_return(['one']) }
  it { is_expected.to run.with_params(%w[a b c d e f g]).and_return(%w[a b c d e f g]) }
  it { is_expected.to run.with_params([['a', 'b', ['c', %w[d e], 'f', 'g']]]).and_return(%w[a b c d e f g]) }
  it { is_expected.to run.with_params(['ã', 'β', ['ĉ', %w[đ ẽ ƒ ġ]]]).and_return(%w[ã β ĉ đ ẽ ƒ ġ]) }
=======
  it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError, %r{Wrong number of arguments}) }
  it { is_expected.to run.with_params([], []).and_raise_error(Puppet::ParseError, %r{Wrong number of arguments}) }
  it { is_expected.to run.with_params(1).and_raise_error(Puppet::ParseError, %r{Requires array}) }
  it { is_expected.to run.with_params('one').and_raise_error(Puppet::ParseError, %r{Requires array}) }

  it { is_expected.to run.with_params([]).and_return([]) }
  it { is_expected.to run.with_params(['one']).and_return(['one']) }
  it { is_expected.to run.with_params([['one']]).and_return(['one']) }
  it { is_expected.to run.with_params(['a', 'b', 'c', 'd', 'e', 'f', 'g']).and_return(['a', 'b', 'c', 'd', 'e', 'f', 'g']) }
  it { is_expected.to run.with_params([['a', 'b', ['c', ['d', 'e'], 'f', 'g']]]).and_return(['a', 'b', 'c', 'd', 'e', 'f', 'g']) }
  it { is_expected.to run.with_params(['ã', 'β', ['ĉ', ['đ', 'ẽ', 'ƒ', 'ġ']]]).and_return(['ã', 'β', 'ĉ', 'đ', 'ẽ', 'ƒ', 'ġ']) }
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
end
