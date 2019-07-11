require 'spec_helper'

describe 'ensure_resources' do
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params.and_raise_error(ArgumentError, %r{Must specify a type}) }
  it { is_expected.to run.with_params('type').and_raise_error(ArgumentError, %r{Must specify a title}) }

  describe 'given a title hash of multiple resources' do
<<<<<<< HEAD
    before(:each) { subject.call(['user', { 'dan' => { 'gid' => 'mygroup', 'uid' => '600' }, 'alex' => { 'gid' => 'mygroup', 'uid' => '700' } }, { 'ensure' => 'present' }]) }
=======
    before(:each) do
      subject.execute('user', { 'dan' => { 'gid' => 'mygroup', 'uid' => '600' }, 'alex' => { 'gid' => 'mygroup', 'uid' => '700' } }, 'ensure' => 'present')
    end
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c

    # this lambda is required due to strangeness within rspec-puppet's expectation handling
    it { expect(-> { catalogue }).to contain_user('dan').with_ensure('present') }
    it { expect(-> { catalogue }).to contain_user('alex').with_ensure('present') }
    it { expect(-> { catalogue }).to contain_user('dan').with('gid' => 'mygroup', 'uid' => '600') }
    it { expect(-> { catalogue }).to contain_user('alex').with('gid' => 'mygroup', 'uid' => '700') }
  end

  describe 'given a title hash of a single resource' do
<<<<<<< HEAD
    before(:each) { subject.call(['user', { 'dan' => { 'gid' => 'mygroup', 'uid' => '600' } }, { 'ensure' => 'present' }]) }
=======
    before(:each) { subject.execute('user', { 'dan' => { 'gid' => 'mygroup', 'uid' => '600' } }, 'ensure' => 'present') }
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c

    # this lambda is required due to strangeness within rspec-puppet's expectation handling
    it { expect(-> { catalogue }).to contain_user('dan').with_ensure('present') }
    it { expect(-> { catalogue }).to contain_user('dan').with('gid' => 'mygroup', 'uid' => '600') }
  end
end
