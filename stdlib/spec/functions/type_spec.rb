require 'spec_helper'

describe 'type' do
  it 'exists' do
    expect(Puppet::Parser::Functions.function('type')).to eq('function_type')
  end

  it 'gives a deprecation warning when called' do
<<<<<<< HEAD
    scope.expects(:warning).with("type() DEPRECATED: This function will cease to function on Puppet 4; please use type3x() before upgrading to puppet 4 for backwards-compatibility, or migrate to the new parser's typing system.") # rubocop:disable Metrics/LineLength : Unable to reduce to required length
=======
    expect(scope).to receive(:warning).with("type() DEPRECATED: This function will cease to function on Puppet 4; please use type3x() before upgrading to puppet 4 for backwards-compatibility, or migrate to the new parser's typing system.") # rubocop:disable Metrics/LineLength : Unable to reduce to required length
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
    scope.function_type(['aoeu'])
  end

  it 'returns string when given a string' do
    result = scope.function_type(['aaabbbbcccc'])
    expect(result).to(eq('string'))
  end

  it 'returns array when given an array' do
<<<<<<< HEAD
    result = scope.function_type([%w[aaabbbbcccc asdf]])
=======
    result = scope.function_type([['aaabbbbcccc', 'asdf']])
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
    expect(result).to(eq('array'))
  end

  it 'returns hash when given a hash' do
    result = scope.function_type([{ 'a' => 1, 'b' => 2 }])
    expect(result).to(eq('hash'))
  end

  it 'returns integer when given an integer' do
    result = scope.function_type(['1'])
    expect(result).to(eq('integer'))
  end

  it 'returns float when given a float' do
    result = scope.function_type(['1.34'])
    expect(result).to(eq('float'))
  end

  it 'returns boolean when given a boolean' do
    result = scope.function_type([true])
    expect(result).to(eq('boolean'))
  end
end
