require 'spec_helper'

describe 'delete_at' do
  it { is_expected.not_to eq(nil) }
<<<<<<< HEAD
  it { is_expected.to run.with_params().and_raise_error(Puppet::ParseError) }
=======
  it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError) }
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
  it { is_expected.to run.with_params('one', 1).and_raise_error(Puppet::ParseError) }
  it { is_expected.to run.with_params(1, 1).and_raise_error(Puppet::ParseError) }
  it { is_expected.to run.with_params(['one'], 'two').and_raise_error(Puppet::ParseError) }
  it {
<<<<<<< HEAD
    pending("Current implementation ignores parameters after the first two.")
=======
    pending('Current implementation ignores parameters after the first two.')
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
    is_expected.to run.with_params(['one'], 0, 1).and_raise_error(Puppet::ParseError)
  }

  describe 'argument validation' do
    it { is_expected.to run.with_params([0, 1, 2], 3).and_raise_error(Puppet::ParseError) }
  end

  it { is_expected.to run.with_params([0, 1, 2], 1).and_return([0, 2]) }
  it { is_expected.to run.with_params([0, 1, 2], -1).and_return([0, 1]) }
  it { is_expected.to run.with_params([0, 1, 2], -4).and_return([0, 1, 2]) }
<<<<<<< HEAD

  it "should leave the original array intact" do
    argument = [1, 2, 3]
    original = argument.dup
    result = subject.call([argument,2])
=======
  it { is_expected.to run.with_params(%w[ƒờở βāř ьầż], 1).and_return(%w[ƒờở ьầż]) }

  it 'leaves the original array intact' do
    argument = [1, 2, 3]
    original = argument.dup
    _result = subject.call([argument, 2])
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
    expect(argument).to eq(original)
  end
end
