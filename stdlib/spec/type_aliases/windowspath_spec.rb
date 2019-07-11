require 'spec_helper'

if Puppet::Util::Package.versioncmp(Puppet.version, '4.5.0') >= 0
  describe 'Stdlib::Windowspath' do
    describe 'valid handling' do
<<<<<<< HEAD
      %w[
        C:\\
        C:\\WINDOWS\\System32
        C:/windows/system32
        X:/foo/bar
        X:\\foo\\bar
        \\\\host\\windows
        X:/var/ůťƒ8
        X:/var/ネット
      ].each do |value|
=======
      ['C:\\', 'C:\\WINDOWS\\System32', 'C:/windows/system32', 'X:/foo/bar', 'X:\\foo\\bar', '\\\\host\\windows', 'X:/var/ůťƒ8', 'X:/var/ネット'].each do |value|
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
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
          '/usr2/username/bin:/usr/local/bin:/usr/bin:.',
          'C;//notright/here',
          'C:noslashes',
          'C:ネット',
          'C:ůťƒ8',
        ].each do |value|
          describe value.inspect do
            it { is_expected.not_to allow_value(value) }
          end
        end
      end
    end
  end
end
