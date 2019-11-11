require 'spec_helper'

describe 'fqdn_uuid' do
  context 'with invalid parameters' do
<<<<<<< HEAD
    it { is_expected.to run.with_params.and_raise_error(ArgumentError, %r{No arguments given$}) }
=======
    it { is_expected.to run.with_params.and_raise_error(ArgumentError, %r{No arguments given}) }
    it { is_expected.to run.with_params('puppetlabs.com', 'google.com').and_raise_error(ArgumentError, %r{Too many arguments given}) }
    it { is_expected.to run.with_params({}).and_raise_error(TypeError, %r{no implicit conversion of Hash}) }
    it { is_expected.to run.with_params(0).and_raise_error(TypeError, %r{no implicit conversion of Integer}) }
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
  end

  context 'with given string' do
    it { is_expected.to run.with_params('puppetlabs.com').and_return('9c70320f-6815-5fc5-ab0f-debe68bf764c') }
    it { is_expected.to run.with_params('google.com').and_return('64ee70a4-8cc1-5d25-abf2-dea6c79a09c8') }
<<<<<<< HEAD
=======
    it { is_expected.to run.with_params('0').and_return('6af613b6-569c-5c22-9c37-2ed93f31d3af') }
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
  end
end
