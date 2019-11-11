require 'spec_helper'
# We can't really test much here, apart from the type roundtrips though the
# parser OK.
describe 'inherit_test1' do
  it {
<<<<<<< HEAD
    should contain_inherit_ini_setting('valid_type').with({
      'value' => 'true',
    })
=======
    is_expected.to contain_inherit_ini_setting('valid_type').with('value' => 'true')
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
  }
end
