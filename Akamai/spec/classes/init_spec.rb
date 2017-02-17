require 'spec_helper'
describe 'Akakai' do
  ontext 'with default values for all parameters' do
    it { should contain_class('Akakai') }
  end
end
if Puppet.version =~ /^(Puppet Enterprise )?3/
    context "foss puppet 3" do
      let(:facts) do
        { :puppetversion => Puppet.version, }
      end
 elsif Puppet.version =~ /^4/
    context "foss puppet 4" do
      let(:facts) do
        { :puppetversion => Puppet.version, }
      end
      describe 'default params' do
        it { should compile.with_all_deps }
      end

