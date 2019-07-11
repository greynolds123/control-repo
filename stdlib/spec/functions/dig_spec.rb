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
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
    scope.function_dig([{}, []])
  end
end
