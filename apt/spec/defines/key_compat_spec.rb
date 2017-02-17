require 'spec_helper'

describe 'apt::key', :type => :define do
<<<<<<< HEAD
  let(:facts) { {
    :lsbdistid => 'Debian',
    :osfamily => 'Debian',
    :puppetversion => Puppet.version,
  } }
=======
  let(:facts) { { :lsbdistid => 'Debian' } }
>>>>>>> 61a94e602d9e9814c0d27f76e0942de0d08f50a1
  GPG_KEY_ID = '47B320EB4C7C375AA9DAE1A01054B7A24BD6EC30'

  let :title do
    GPG_KEY_ID
  end

<<<<<<< HEAD
  let :pre_condition do
    'include apt'
  end

  describe 'normal operation' do
    describe 'default options' do
      it {
        is_expected.to contain_apt_key(title).with({
          :id                => title,
          :ensure            => 'present',
          :source            => nil,
          :server            => 'keyserver.ubuntu.com',
          :content           => nil,
          :keyserver_options => nil,
        })
      }
      it 'contains the apt_key present anchor' do
        is_expected.to contain_anchor("apt_key #{title} present")
=======
  describe 'normal operation' do
    describe 'default options' do
      it 'contains the apt_key' do
        should contain_apt_key(title).with({
          :id                => title,
          :ensure            => 'present',
          :source            => nil,
          :server            => nil,
          :content           => nil,
          :keyserver_options => nil,
        })
      end
      it 'contains the apt_key present anchor' do
        should contain_anchor("apt_key #{title} present")
>>>>>>> 61a94e602d9e9814c0d27f76e0942de0d08f50a1
      end
    end

    describe 'title and key =>' do
      let :title do
        'puppetlabs'
      end

      let :params do {
        :key => GPG_KEY_ID,
      } end

      it 'contains the apt_key' do
<<<<<<< HEAD
        is_expected.to contain_apt_key(title).with({
          :id                => GPG_KEY_ID,
          :ensure            => 'present',
          :source            => nil,
          :server            => 'keyserver.ubuntu.com',
=======
        should contain_apt_key(title).with({
          :id                => GPG_KEY_ID,
          :ensure            => 'present',
          :source            => nil,
          :server            => nil,
>>>>>>> 61a94e602d9e9814c0d27f76e0942de0d08f50a1
          :content           => nil,
          :keyserver_options => nil,
        })
      end
      it 'contains the apt_key present anchor' do
<<<<<<< HEAD
        is_expected.to contain_anchor("apt_key #{GPG_KEY_ID} present")
=======
        should contain_anchor("apt_key #{GPG_KEY_ID} present")
>>>>>>> 61a94e602d9e9814c0d27f76e0942de0d08f50a1
      end
    end

    describe 'ensure => absent' do
      let :params do {
        :ensure => 'absent',
      } end

      it 'contains the apt_key' do
<<<<<<< HEAD
        is_expected.to contain_apt_key(title).with({
          :id                => title,
          :ensure            => 'absent',
          :source            => nil,
          :server            => 'keyserver.ubuntu.com',
=======
        should contain_apt_key(title).with({
          :id                => title,
          :ensure            => 'absent',
          :source            => nil,
          :server            => nil,
>>>>>>> 61a94e602d9e9814c0d27f76e0942de0d08f50a1
          :content           => nil,
          :keyserver_options => nil,
        })
      end
      it 'contains the apt_key absent anchor' do
<<<<<<< HEAD
        is_expected.to contain_anchor("apt_key #{title} absent")
=======
        should contain_anchor("apt_key #{title} absent")
>>>>>>> 61a94e602d9e9814c0d27f76e0942de0d08f50a1
      end
    end

    describe 'set a bunch of things!' do
      let :params do {
        :key_content => 'GPG key content',
        :key_source => 'http://apt.puppetlabs.com/pubkey.gpg',
        :key_server => 'pgp.mit.edu',
        :key_options => 'debug',
      } end

      it 'contains the apt_key' do
<<<<<<< HEAD
        is_expected.to contain_apt_key(title).with({
=======
        should contain_apt_key(title).with({
>>>>>>> 61a94e602d9e9814c0d27f76e0942de0d08f50a1
          :id      => title,
          :ensure  => 'present',
          :source  => 'http://apt.puppetlabs.com/pubkey.gpg',
          :server  => 'pgp.mit.edu',
          :content => params[:key_content],
          :options => 'debug',
        })
      end
      it 'contains the apt_key present anchor' do
<<<<<<< HEAD
        is_expected.to contain_anchor("apt_key #{title} present")
=======
        should contain_anchor("apt_key #{title} present")
>>>>>>> 61a94e602d9e9814c0d27f76e0942de0d08f50a1
      end
    end

    context "domain with dash" do
      let(:params) do{
        :key_server => 'p-gp.m-it.edu',
      } end
      it 'contains the apt_key' do
<<<<<<< HEAD
        is_expected.to contain_apt_key(title).with({
=======
        should contain_apt_key(title).with({
>>>>>>> 61a94e602d9e9814c0d27f76e0942de0d08f50a1
          :id        => title,
          :server => 'p-gp.m-it.edu',
        })
      end
    end

    context "url" do
      let :params do
        {
          :key_server => 'hkp://pgp.mit.edu',
        }
      end
      it 'contains the apt_key' do
<<<<<<< HEAD
        is_expected.to contain_apt_key(title).with({
=======
        should contain_apt_key(title).with({
>>>>>>> 61a94e602d9e9814c0d27f76e0942de0d08f50a1
          :id        => title,
          :server => 'hkp://pgp.mit.edu',
        })
      end
    end
    context "url with port number" do
      let :params do
        {
          :key_server => 'hkp://pgp.mit.edu:80',
        }
      end
      it 'contains the apt_key' do
<<<<<<< HEAD
        is_expected.to contain_apt_key(title).with({
=======
        should contain_apt_key(title).with({
>>>>>>> 61a94e602d9e9814c0d27f76e0942de0d08f50a1
          :id        => title,
          :server => 'hkp://pgp.mit.edu:80',
        })
      end
    end
  end

  describe 'validation' do
    context "domain begin with dash" do
      let(:params) do{
        :key_server => '-pgp.mit.edu',
      } end
      it 'fails' do
        expect { subject.call } .to raise_error(/does not match/)
      end
    end

    context "domain begin with dot" do
      let(:params) do{
        :key_server => '.pgp.mit.edu',
      } end
      it 'fails' do
        expect { subject.call } .to raise_error(/does not match/)
      end
    end

    context "domain end with dot" do
      let(:params) do{
        :key_server => "pgp.mit.edu.",
      } end
      it 'fails' do
        expect { subject.call } .to raise_error(/does not match/)
      end
    end
    context "exceed character url" do
      let :params do
        {
          :key_server => 'hkp://pgpiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii.mit.edu'
        }
      end
      it 'fails' do
        expect { subject.call }.to raise_error(/does not match/)
      end
    end
    context "incorrect port number url" do
      let :params do
        {
          :key_server => 'hkp://pgp.mit.edu:8008080'
        }
      end
      it 'fails' do
        expect { subject.call }.to raise_error(/does not match/)
      end
    end
    context "incorrect protocol for  url" do
      let :params do
        {
          :key_server => 'abc://pgp.mit.edu:80'
        }
      end
      it 'fails' do
        expect { subject.call }.to raise_error(/does not match/)
      end
    end
    context "missing port number url" do
      let :params do
        {
          :key_server => 'hkp://pgp.mit.edu:'
        }
      end
      it 'fails' do
        expect { subject.call }.to raise_error(/does not match/)
      end
    end
    context "url ending with a dot" do
      let :params do
        {
          :key_server => 'hkp://pgp.mit.edu.'
        }
      end
      it 'fails' do
        expect { subject.call }.to raise_error(/does not match/)
      end
    end
    context "url begin with a dash" do
      let(:params) do{
        :key_server => "hkp://-pgp.mit.edu",
      } end
      it 'fails' do
        expect { subject.call }.to raise_error(/does not match/)
      end
    end
    context 'invalid key' do
      let :title do
        'Out of rum. Why? Why are we out of rum?'
      end
      it 'fails' do
        expect { subject.call }.to raise_error(/does not match/)
      end
    end

    context 'invalid source' do
      let :params do {
        :key_source => 'afp://puppetlabs.com/key.gpg',
      } end
      it 'fails' do
        expect { subject.call }.to raise_error(/does not match/)
      end
    end

    context 'invalid content' do
      let :params do {
        :key_content => [],
      } end
      it 'fails' do
        expect { subject.call }.to raise_error(/is not a string/)
      end
    end

    context 'invalid server' do
      let :params do {
        :key_server => 'two bottles of rum',
      } end
      it 'fails' do
        expect { subject.call }.to raise_error(/does not match/)
      end
    end

    context 'invalid keyserver_options' do
      let :params do {
        :key_options => {},
      } end
      it 'fails' do
        expect { subject.call }.to raise_error(/is not a string/)
      end
    end

    context 'invalid ensure' do
      let :params do
        {
          :ensure => 'foo',
        }
      end
      it 'fails' do
        expect { subject.call }.to raise_error(/does not match/)
      end
    end

    describe 'duplication' do
      context 'two apt::key resources for same key, different titles' do
        let :pre_condition do
<<<<<<< HEAD
          "#{super()}\napt::key { 'duplicate': key => '#{title}', }"
        end

        it 'contains the duplicate apt::key resource' do
          is_expected.to contain_apt__key('duplicate').with({
            :key    => title,
            :ensure => 'present',
          })
        end

        it 'contains the original apt::key resource' do
          is_expected.to contain_apt__key(title).with({
=======
          "apt::key { 'duplicate': key => '#{title}', }"
        end

        it 'contains two apt::key resources' do
          should contain_apt__key('duplicate').with({
            :key    => title,
            :ensure => 'present',
          })
          should contain_apt__key(title).with({
>>>>>>> 61a94e602d9e9814c0d27f76e0942de0d08f50a1
            :id     => title,
            :ensure => 'present',
          })
        end

<<<<<<< HEAD
        it 'contains the native apt_key' do
          is_expected.to contain_apt_key('duplicate').with({
            :id                => title,
            :ensure            => 'present',
            :source            => nil,
            :server            => 'keyserver.ubuntu.com',
            :content           => nil,
            :keyserver_options => nil,
          })
        end

        it 'does not contain the original apt_key' do
          is_expected.not_to contain_apt_key(title)
=======
        it 'contains only a single apt_key' do
          should contain_apt_key('duplicate').with({
            :id                => title,
            :ensure            => 'present',
            :source            => nil,
            :server            => nil,
            :content           => nil,
            :keyserver_options => nil,
          })
          should_not contain_apt_key(title)
>>>>>>> 61a94e602d9e9814c0d27f76e0942de0d08f50a1
        end
      end

      context 'two apt::key resources, different ensure' do
        let :pre_condition do
<<<<<<< HEAD
          "#{super()}\napt::key { 'duplicate': key => '#{title}', ensure => 'absent', }"
=======
          "apt::key { 'duplicate': key => '#{title}', ensure => 'absent', }"
>>>>>>> 61a94e602d9e9814c0d27f76e0942de0d08f50a1
        end
        it 'informs the user of the impossibility' do
          expect { subject.call }.to raise_error(/already ensured as absent/)
        end
      end
    end
  end
end
