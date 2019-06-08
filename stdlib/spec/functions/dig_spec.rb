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
>>>>>>> f661b3a03526f113b1823084ffd4808cf261cf70
    scope.function_dig([{}, []])
  end
end
