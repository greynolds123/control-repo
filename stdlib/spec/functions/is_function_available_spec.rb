require 'spec_helper'

describe 'is_function_available' do
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i) }
  it { is_expected.to run.with_params('one', 'two').and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i) }
  it { is_expected.to run.with_params('include').and_return(true) }
  it { is_expected.to run.with_params('no_such_function').and_return(false) }
<<<<<<< HEAD
=======
  it { is_expected.to run.with_params([]).and_return(false) }
  it { is_expected.to run.with_params({}).and_return(false) }
  it { is_expected.to run.with_params(1).and_return(false) }
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
end
