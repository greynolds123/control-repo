require 'spec_helper'

describe 'shell_escape' do
  it { is_expected.not_to eq(nil) }

  describe 'signature validation' do
<<<<<<< HEAD
    it { is_expected.to run.with_params().and_raise_error(Puppet::ParseError, /wrong number of arguments/i) }
    it { is_expected.to run.with_params('foo', 'bar').and_raise_error(Puppet::ParseError, /wrong number of arguments/i) }
=======
    it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i) }
    it { is_expected.to run.with_params('foo', 'bar').and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i) }
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
  end

  describe 'stringification' do
    it { is_expected.to run.with_params(10).and_return('10') }
    it { is_expected.to run.with_params(false).and_return('false') }
  end

  describe 'escaping' do
    it { is_expected.to run.with_params('foo').and_return('foo') }
    it { is_expected.to run.with_params('foo bar').and_return('foo\ bar') }
<<<<<<< HEAD
    it { is_expected.to run.with_params('~`!@#$%^&*()_+-=[]\{}|;\':",./<>?')
           .and_return('\~\`\!@\#\$\%\^\&\*\(\)_\+-\=\[\]\\\\\{\}\|\;\\\':\",./\<\>\?') }
=======
    it {
      is_expected.to run.with_params('~`!@#$%^&*()_+-=[]\{}|;\':",./<>?')
                        .and_return('\~\`\!@\#\$\%\^\&\*\(\)_\+-\=\[\]\\\\\{\}\|\;\\\':\",./\<\>\?')
    }
  end

  context 'with UTF8 and double byte characters' do
    it { is_expected.to run.with_params('スペー スを含むテ  キスト').and_return('\\ス\\ペ\\ー\\ \\ス\\を\\含\\む\\テ\\ \\ \\キ\\ス\\ト') }
    it { is_expected.to run.with_params('μťƒ 8  ŧĕχť').and_return('\\μ\\ť\\ƒ\\ 8\\ \\ \\ŧ\\ĕ\\χ\\ť') }
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
  end
end
