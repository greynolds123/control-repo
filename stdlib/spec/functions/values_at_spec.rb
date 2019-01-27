require 'spec_helper'

describe 'values_at' do
  describe 'signature validation' do
    it { is_expected.not_to eq(nil) }
<<<<<<< HEAD
    it { is_expected.to run.with_params().and_raise_error(Puppet::ParseError, /wrong number of arguments/i) }
    it { is_expected.to run.with_params([]).and_raise_error(Puppet::ParseError, /wrong number of arguments/i) }
    it {
      pending("Current implementation ignores parameters after the first two.")
      is_expected.to run.with_params([], 0, 1).and_raise_error(Puppet::ParseError, /wrong number of arguments/i)
    }
    it { is_expected.to run.with_params('', 1).and_raise_error(Puppet::ParseError, /Requires array/i) }
    it { is_expected.to run.with_params({}, 1).and_raise_error(Puppet::ParseError, /Requires array/i) }
    it { is_expected.to run.with_params(true, 1).and_raise_error(Puppet::ParseError, /Requires array/i) }
    it { is_expected.to run.with_params(1, 1).and_raise_error(Puppet::ParseError, /Requires array/i) }
    it { is_expected.to run.with_params([0,1,2], 'two').and_raise_error(Puppet::ParseError, /Unknown format of given index/) }
    it { is_expected.to run.with_params([0,1,2], []).and_raise_error(Puppet::ParseError, /provide at least one positive index/) }
    it { is_expected.to run.with_params([0,1,2], '-1-1').and_raise_error(Puppet::ParseError, /Unknown format of given index/) }
    it { is_expected.to run.with_params([0,1,2], '2-1').and_raise_error(Puppet::ParseError, /Stop index in given indices range is smaller than the start index/) }
  end

  context 'when requesting a single item' do
    it { is_expected.to run.with_params([0, 1, 2], -1).and_raise_error(Puppet::ParseError, /Unknown format of given index/) }
=======
    it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i) }
    it { is_expected.to run.with_params([]).and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i) }
    it {
      pending('Current implementation ignores parameters after the first two.')
      is_expected.to run.with_params([], 0, 1).and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i)
    }
    it { is_expected.to run.with_params('', 1).and_raise_error(Puppet::ParseError, %r{Requires array}i) }
    it { is_expected.to run.with_params({}, 1).and_raise_error(Puppet::ParseError, %r{Requires array}i) }
    it { is_expected.to run.with_params(true, 1).and_raise_error(Puppet::ParseError, %r{Requires array}i) }
    it { is_expected.to run.with_params(1, 1).and_raise_error(Puppet::ParseError, %r{Requires array}i) }
    it { is_expected.to run.with_params([0, 1, 2], 'two').and_raise_error(Puppet::ParseError, %r{Unknown format of given index}) }
    it { is_expected.to run.with_params([0, 1, 2], []).and_raise_error(Puppet::ParseError, %r{provide at least one positive index}) }
    it { is_expected.to run.with_params([0, 1, 2], '-1-1').and_raise_error(Puppet::ParseError, %r{Unknown format of given index}) }
    it { is_expected.to run.with_params([0, 1, 2], '2-1').and_raise_error(Puppet::ParseError, %r{Stop index in given indices range is smaller than the start index}) }
  end

  context 'when requesting a single item' do
    it { is_expected.to run.with_params([0, 1, 2], -1).and_raise_error(Puppet::ParseError, %r{Unknown format of given index}) }
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
    it { is_expected.to run.with_params([0, 1, 2], 0).and_return([0]) }
    it { is_expected.to run.with_params([0, 1, 2], 1).and_return([1]) }
    it { is_expected.to run.with_params([0, 1, 2], [1]).and_return([1]) }
    it { is_expected.to run.with_params([0, 1, 2], '1').and_return([1]) }
    it { is_expected.to run.with_params([0, 1, 2], '1-1').and_return([1]) }
    it { is_expected.to run.with_params([0, 1, 2], 2).and_return([2]) }
<<<<<<< HEAD
    it { is_expected.to run.with_params([0, 1, 2], 3).and_raise_error(Puppet::ParseError, /index exceeds array size/) }
  end

  context 'when requesting multiple items' do
    it { is_expected.to run.with_params([0, 1, 2], [1, -1]).and_raise_error(Puppet::ParseError, /Unknown format of given index/) }
    it { is_expected.to run.with_params([0, 1, 2], [0, 2]).and_return([0, 2]) }
    it { is_expected.to run.with_params([0, 1, 2], ['0-2', 1, 2]).and_return([0, 1, 2, 1, 2]) }
    it { is_expected.to run.with_params([0, 1, 2], [3, 2]).and_raise_error(Puppet::ParseError, /index exceeds array size/) }
=======
    it { is_expected.to run.with_params([0, 1, 2], 3).and_raise_error(Puppet::ParseError, %r{index exceeds array size}) }
  end

  context 'when requesting a single item using UTF8 and double byte characters' do
    it { is_expected.to run.with_params(%w[ẩ β с ď], 0).and_return(['ẩ']) }
    it { is_expected.to run.with_params(%w[文 字 の 値], 2).and_return(['の']) }
  end

  context 'when requesting multiple items' do
    it { is_expected.to run.with_params([0, 1, 2], [1, -1]).and_raise_error(Puppet::ParseError, %r{Unknown format of given index}) }
    it { is_expected.to run.with_params([0, 1, 2], [0, 2]).and_return([0, 2]) }
    it { is_expected.to run.with_params([0, 1, 2], ['0-2', 1, 2]).and_return([0, 1, 2, 1, 2]) }
    it { is_expected.to run.with_params([0, 1, 2], [3, 2]).and_raise_error(Puppet::ParseError, %r{index exceeds array size}) }
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19

    describe 'different range syntaxes' do
      it { is_expected.to run.with_params([0, 1, 2], '0-2').and_return([0, 1, 2]) }
      it { is_expected.to run.with_params([0, 1, 2], '0..2').and_return([0, 1, 2]) }
      it { is_expected.to run.with_params([0, 1, 2], '0...2').and_return([0, 1]) }
      it {
        pending('fix this bounds check')
        is_expected.to run.with_params([0, 1, 2], '0...3').and_return([0, 1, 2])
      }
    end
  end
end
