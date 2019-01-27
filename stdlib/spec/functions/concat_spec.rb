require 'spec_helper'

describe 'concat' do
  it { is_expected.not_to eq(nil) }
<<<<<<< HEAD
  it { is_expected.to run.with_params().and_raise_error(Puppet::ParseError) }
  it { is_expected.to run.with_params([1]).and_raise_error(Puppet::ParseError) }
  it { is_expected.to run.with_params(1, [2]).and_raise_error(Puppet::ParseError) }
  it { is_expected.to run.with_params([1], [2], [3]).and_return([1, 2, 3]) }
  it { is_expected.to run.with_params(['1','2','3'],['4','5','6']).and_return(['1','2','3','4','5','6']) }
  it { is_expected.to run.with_params(['1','2','3'],'4').and_return(['1','2','3','4']) }
  it { is_expected.to run.with_params(['1','2','3'],[['4','5'],'6']).and_return(['1','2','3',['4','5'],'6']) }
  it { is_expected.to run.with_params(['1','2'],['3','4'],['5','6']).and_return(['1','2','3','4','5','6']) }
  it { is_expected.to run.with_params(['1','2'],'3','4',['5','6']).and_return(['1','2','3','4','5','6']) }
  it { is_expected.to run.with_params([{"a" => "b"}], {"c" => "d", "e" => "f"}).and_return([{"a" => "b"}, {"c" => "d", "e" => "f"}]) }

  it "should leave the original array intact" do
    argument1 = ['1','2','3']
    original1 = argument1.dup
    argument2 = ['4','5','6']
    original2 = argument2.dup
    result = subject.call([argument1,argument2])
    expect(argument1).to eq(original1)
    expect(argument2).to eq(original2)
=======
  it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError) }
  it { is_expected.to run.with_params([1]).and_raise_error(Puppet::ParseError) }
  it { is_expected.to run.with_params(1, [2]).and_raise_error(Puppet::ParseError) }
  it { is_expected.to run.with_params([1], [2], [3]).and_return([1, 2, 3]) }
  it { is_expected.to run.with_params(%w[1 2 3], %w[4 5 6]).and_return(%w[1 2 3 4 5 6]) }
  it { is_expected.to run.with_params(%w[1 2 3], '4').and_return(%w[1 2 3 4]) }
  it { is_expected.to run.with_params(%w[1 2 3], [%w[4 5], '6']).and_return(['1', '2', '3', %w[4 5], '6']) }
  it { is_expected.to run.with_params(%w[1 2], %w[3 4], %w[5 6]).and_return(%w[1 2 3 4 5 6]) }
  it { is_expected.to run.with_params(%w[1 2], '3', '4', %w[5 6]).and_return(%w[1 2 3 4 5 6]) }

  context 'with UTF8 and double byte characters' do
    it { is_expected.to run.with_params([{ 'a' => 'b' }], 'c' => 'd', 'e' => 'f').and_return([{ 'a' => 'b' }, { 'c' => 'd', 'e' => 'f' }]) }
    it { is_expected.to run.with_params(['ấ', 'β', '©'], %w[đ ể 文字列]).and_return(['ấ', 'β', '©', 'đ', 'ể', '文字列']) }
  end

  arguments = [%w[1 2 3], %w[4 5 6]]
  originals = [arguments[0].dup, arguments[1].dup]
  it 'leaves the original array intact' do
    _result = subject.call([arguments[0], arguments[1]])
    arguments.each_with_index do |argument, index|
      expect(argument).to eq(originals[index])
    end
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
  end
end
