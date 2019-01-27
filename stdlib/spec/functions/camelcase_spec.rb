require 'spec_helper'

describe 'camelcase' do
  it { is_expected.not_to eq(nil) }
<<<<<<< HEAD
  it { is_expected.to run.with_params().and_raise_error(Puppet::ParseError) }
  it { is_expected.to run.with_params(100).and_raise_error(Puppet::ParseError) }
  it { is_expected.to run.with_params("abc").and_return("Abc") }
  it { is_expected.to run.with_params("aa_bb_cc").and_return("AaBbCc") }
  it { is_expected.to run.with_params("_aa__bb__cc_").and_return("AaBbCc") }
  it { is_expected.to run.with_params("100").and_return("100") }
  it { is_expected.to run.with_params("1_00").and_return("100") }
  it { is_expected.to run.with_params("_").and_return("") }
  it { is_expected.to run.with_params("").and_return("") }
  it { is_expected.to run.with_params([]).and_return([]) }
  it { is_expected.to run.with_params(["abc", "aa_bb_cc"]).and_return(["Abc", "AaBbCc"]) }
  it { is_expected.to run.with_params(["abc", 1, "aa_bb_cc"]).and_return(["Abc", 1, "AaBbCc"]) }
=======
  it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError) }
  it { is_expected.to run.with_params(100).and_raise_error(Puppet::ParseError) }
  it { is_expected.to run.with_params('abc').and_return('Abc') }
  it { is_expected.to run.with_params('aa_bb_cc').and_return('AaBbCc') }
  it { is_expected.to run.with_params('_aa__bb__cc_').and_return('AaBbCc') }
  it { is_expected.to run.with_params('100').and_return('100') }
  it { is_expected.to run.with_params('1_00').and_return('100') }
  it { is_expected.to run.with_params('_').and_return('') }
  it { is_expected.to run.with_params('').and_return('') }
  it { is_expected.to run.with_params([]).and_return([]) }
  it { is_expected.to run.with_params(%w[abc aa_bb_cc]).and_return(%w[Abc AaBbCc]) }
  it { is_expected.to run.with_params(['abc', 1, 'aa_bb_cc']).and_return(['Abc', 1, 'AaBbCc']) }
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
end
