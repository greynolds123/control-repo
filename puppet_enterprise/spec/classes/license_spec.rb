require 'spec_helper'

describe 'puppet_enterprise::license' do
  before :each do
    @fake_license = Tempfile.new('license.key')
    File.open(@fake_license, 'w') { |f| f.write 'fake license key' }

    @params = {}
  end

  let(:params) { @params }

  context "deprecation warning" do
    before :each do
      @params = {
        'license_key' => @fake_license.path,
      }
    end

    it { should contain_notify('puppet_enterprise::license::license_key deprecation') }
    it { should contain_file('/etc/puppetlabs/license.key').with_content('fake license key') }
  end

  context "default" do
    it { should_not contain_notify('puppet_enterprise::license::license_key deprecation') }
  end
end
