require 'spec_helper'

describe 'puppet_enterprise::profile::console::proxy::nginx_conf' do
  before :each do
    @params = { 'gzip' => 'on'}
  end

  let(:params) { @params }

  def should_have_directive(name, value)
    should contain_pe_nginx__directive(name).with_value(value).with('directive_ensure' => 'present')
  end

  context 'default parameters' do
    it { should_have_directive('gzip', 'on') }
    it { should_have_directive('gzip_comp_level', 5) }
    it { should_have_directive('gzip_min_length', 256) }
    it { should_have_directive('gzip_proxied', 'any') }
    it { should_have_directive('gzip_vary', 'on') }
    it { should contain_pe_nginx__directive('gzip_types') }
  end

  context 'disabling gzip setting in nginx' do
    before :each do
      @params['gzip'] = 'off'
    end
    it { should_have_directive('gzip', 'off') }
    it { should contain_pe_nginx__directive('gzip_comp_level').with('directive_ensure' => 'absent') }
    it { should contain_pe_nginx__directive('gzip_min_length').with('directive_ensure' => 'absent') }
    it { should contain_pe_nginx__directive('gzip_proxied').with('directive_ensure' => 'absent') }
    it { should contain_pe_nginx__directive('gzip_vary').with('directive_ensure' => 'absent') }
    it { should contain_pe_nginx__directive('gzip_types').with('directive_ensure' => 'absent') }
  end
end
