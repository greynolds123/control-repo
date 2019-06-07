require 'spec_helper'

if Puppet::Util::Package.versioncmp(Puppet.version, '4.5.0') >= 0
  describe 'Stdlib::Base64' do
    describe 'valid handling' do
<<<<<<< HEAD
      %w[
        asdasdASDSADA342386832/746+=
        asdasdASDSADA34238683274/6+
        asdasdASDSADA3423868327/46+==
      ].each do |value|
=======
      ['asdasdASDSADA342386832/746+=', 'asdasdASDSADA34238683274/6+', 'asdasdASDSADA3423868327/46+=='].each do |value|
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
          'asdasd!@#$',
          '=asdasd9879876876+/',
          'asda=sd9879876876+/',
          'asdaxsd9879876876+/===',
          'asdads asdasd',
        ].each do |value|
          describe value.inspect do
            it { is_expected.not_to allow_value(value) }
          end
        end
      end
    end
  end
end
