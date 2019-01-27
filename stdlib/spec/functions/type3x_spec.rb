require 'spec_helper'

describe 'type3x' do
<<<<<<< HEAD
  it "should exist" do
    expect(Puppet::Parser::Functions.function("type3x")).to eq("function_type3x")
  end

  it "should raise a ParseError if there is less than 1 arguments" do
    expect { scope.function_type3x([]) }.to( raise_error(Puppet::ParseError))
  end

  it "should return string when given a string" do
    result = scope.function_type3x(["aaabbbbcccc"])
    expect(result).to(eq('string'))
  end

  it "should return array when given an array" do
    result = scope.function_type3x([["aaabbbbcccc","asdf"]])
    expect(result).to(eq('array'))
  end

  it "should return hash when given a hash" do
    result = scope.function_type3x([{"a"=>1,"b"=>2}])
    expect(result).to(eq('hash'))
  end

  it "should return integer when given an integer" do
    result = scope.function_type3x(["1"])
    expect(result).to(eq('integer'))
  end

  it "should return float when given a float" do
    result = scope.function_type3x(["1.34"])
    expect(result).to(eq('float'))
  end

  it "should return boolean when given a boolean" do
=======
  it 'exists' do
    expect(Puppet::Parser::Functions.function('type3x')).to eq('function_type3x')
  end

  it 'raises a ParseError if there is less than 1 arguments' do
    expect { scope.function_type3x([]) }.to(raise_error(Puppet::ParseError))
  end

  it 'returns string when given a string' do
    result = scope.function_type3x(['aaabbbbcccc'])
    expect(result).to(eq('string'))
  end

  it 'returns array when given an array' do
    result = scope.function_type3x([%w[aaabbbbcccc asdf]])
    expect(result).to(eq('array'))
  end

  it 'returns hash when given a hash' do
    result = scope.function_type3x([{ 'a' => 1, 'b' => 2 }])
    expect(result).to(eq('hash'))
  end

  it 'returns integer when given an integer' do
    result = scope.function_type3x(['1'])
    expect(result).to(eq('integer'))
  end

  it 'returns float when given a float' do
    result = scope.function_type3x(['1.34'])
    expect(result).to(eq('float'))
  end

  it 'returns boolean when given a boolean' do
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
    result = scope.function_type3x([true])
    expect(result).to(eq('boolean'))
  end
end
