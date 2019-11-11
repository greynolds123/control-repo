require 'spec_helper'

describe 'dig' do
  it 'exists' do
    expect(Puppet::Parser::Functions.function('dig')).to eq('function_dig')
  end

  it 'gives a deprecation warning when called' do
<<<<<<< HEAD
    scope.expects(:warning).with('dig() DEPRECATED: This function has been replaced in Puppet 4.5.0, please use dig44() for backwards compatibility or use the new version.')
=======
    expect(scope).to receive(:warning).with('dig() DEPRECATED: This function has been replaced in Puppet 4.5.0, please use dig44() for backwards compatibility or use the new version.')
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
    scope.function_dig([{}, []])
  end
end
