require 'spec_helper'

if Puppet::Util::Package.versioncmp(Puppet.version, '4.5.0') >= 0
  describe 'Stdlib::HTTPSUrl' do
    describe 'valid handling' do
<<<<<<< HEAD
      %w[
        https://hello.com
        https://notcreative.org
        https://notexciting.co.uk
        https://graphemica.com/❤
        https://graphemica.com/緩
      ].each do |value|
=======
      ['https://hello.com', 'https://notcreative.org', 'https://notexciting.co.uk', 'https://graphemica.com/❤', 'https://graphemica.com/緩', 'HTTPS://FOO.com'].each do |value|
>>>>>>> f661b3a03526f113b1823084ffd4808cf261cf70
        describe value.inspect do
          it { is_expected.to allow_value(value) }
        end
      end
    end

    describe 'invalid path handling' do
      context 'with garbage inputs' do
        [
          nil,
          [nil],
          [nil, nil],
          { 'foo' => 'bar' },
          {},
          '',
          'httds://notquiteright.org',
          'hptts:/nah',
          'https;//notrightbutclose.org',
          'http://graphemica.com/❤',
          'http://graphemica.com/緩',
        ].each do |value|
          describe value.inspect do
            it { is_expected.not_to allow_value(value) }
          end
        end
      end
    end
  end
end
