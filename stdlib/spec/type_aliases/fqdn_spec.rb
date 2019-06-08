require 'spec_helper'

if Puppet::Util::Package.versioncmp(Puppet.version, '4.5.0') >= 0
  describe 'Stdlib::Fqdn' do
    describe 'valid handling' do
<<<<<<< HEAD
      %w[
        example
        example.com
        www.example.com
      ].each do |value|
=======
      ['example', 'example.com', 'www.example.com'].each do |value|
>>>>>>> f661b3a03526f113b1823084ffd4808cf261cf70
        describe value.inspect do
          it { is_expected.to allow_value(value) }
        end
      end
    end

    describe 'invalid path handling' do
      context 'garbage inputs' do
        [
          [nil],
          [nil, nil],
          { 'foo' => 'bar' },
          {},
          '',
          '2001:DB8::1',
          'www www.example.com',
        ].each do |value|
          describe value.inspect do
            it { is_expected.not_to allow_value(value) }
          end
        end
      end
    end
  end
end
