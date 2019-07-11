<<<<<<< HEAD
=======
# coding: utf-8

>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
require 'spec_helper'

if Puppet::Util::Package.versioncmp(Puppet.version, '4.5.0') >= 0
  describe 'Stdlib::Filemode' do
    describe 'valid modes' do
<<<<<<< HEAD
      %w[
        0644
        1644
        2644
        4644
        0123
        0777
=======
      [
        '7',
        '12',
        '666',

        '0000',
        '0644',
        '1644',
        '2644',
        '4644',
        '0123',
        '0777',

        'a=,o-r,u+X,g=w',
        'a=Xr,+0',
        'u=rwx,g+rX',
        'u+s,g-s',
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
      ].each do |value|
        describe value.inspect do
          it { is_expected.to allow_value(value) }
        end
      end
    end

    describe 'invalid modes' do
      context 'with garbage inputs' do
        [
<<<<<<< HEAD
=======
          true,
          false,
          :keyword,
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
          nil,
          [nil],
          [nil, nil],
          { 'foo' => 'bar' },
          {},
          '',
          'ネット',
<<<<<<< HEAD
          '644',
          '7777',
          '1',
          '22',
          '333',
          '55555',
          '0x123',
          '0649',
=======
          '55555',
          '0x123',
          '0649',

          '=8,X',
          'x=r,a=wx',
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
        ].each do |value|
          describe value.inspect do
            it { is_expected.not_to allow_value(value) }
          end
        end
      end
    end
  end
end
