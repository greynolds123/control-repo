require 'spec_helper'

describe 'uriescape' do
  describe 'signature validation' do
    it { is_expected.not_to eq(nil) }
<<<<<<< HEAD
    it { is_expected.to run.with_params().and_raise_error(Puppet::ParseError, /wrong number of arguments/i) }
    it {
      pending("Current implementation ignores parameters after the first.")
      is_expected.to run.with_params('', '').and_raise_error(Puppet::ParseError, /wrong number of arguments/i)
    }
    it { is_expected.to run.with_params(1).and_raise_error(Puppet::ParseError, /Requires either array or string to work/) }
    it { is_expected.to run.with_params({}).and_raise_error(Puppet::ParseError, /Requires either array or string to work/) }
    it { is_expected.to run.with_params(true).and_raise_error(Puppet::ParseError, /Requires either array or string to work/) }
  end

  describe 'handling normal strings' do
    it 'should call ruby\'s URI.escape function' do
      URI.expects(:escape).with('uri_string').returns('escaped_uri_string').once
      is_expected.to run.with_params('uri_string').and_return('escaped_uri_string') 
=======
    it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i) }
    it {
      pending('Current implementation ignores parameters after the first.')
      is_expected.to run.with_params('', '').and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i)
    }
    it { is_expected.to run.with_params(1).and_raise_error(Puppet::ParseError, %r{Requires either array or string to work}) }
    it { is_expected.to run.with_params({}).and_raise_error(Puppet::ParseError, %r{Requires either array or string to work}) }
    it { is_expected.to run.with_params(true).and_raise_error(Puppet::ParseError, %r{Requires either array or string to work}) }
  end

  describe 'handling normal strings' do
    it 'calls ruby\'s URI.escape function' do
      URI.expects(:escape).with('uri_string').returns('escaped_uri_string').once
      is_expected.to run.with_params('uri_string').and_return('escaped_uri_string')
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
    end
  end

  describe 'handling classes derived from String' do
<<<<<<< HEAD
    it 'should call ruby\'s URI.escape function' do
      uri_string = AlsoString.new('uri_string')
      URI.expects(:escape).with(uri_string).returns('escaped_uri_string').once
      is_expected.to run.with_params(uri_string).and_return("escaped_uri_string") 
=======
    it 'calls ruby\'s URI.escape function' do
      uri_string = AlsoString.new('uri_string')
      URI.expects(:escape).with(uri_string).returns('escaped_uri_string').once
      is_expected.to run.with_params(uri_string).and_return('escaped_uri_string')
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
    end
  end

  describe 'strings in arrays handling' do
    it { is_expected.to run.with_params([]).and_return([]) }
<<<<<<< HEAD
    it { is_expected.to run.with_params(["one}", "two"]).and_return(["one%7D", "two"]) }
    it { is_expected.to run.with_params(["one}", 1, true, {}, "two"]).and_return(["one%7D", 1, true, {}, "two"]) }
=======
    it { is_expected.to run.with_params(['one}', 'two']).and_return(['one%7D', 'two']) }
    it { is_expected.to run.with_params(['one}', 1, true, {}, 'two']).and_return(['one%7D', 1, true, {}, 'two']) }
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
  end
end
