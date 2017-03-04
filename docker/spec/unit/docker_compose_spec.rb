require 'spec_helper'

compose = Puppet::Type.type(:docker_compose)

describe compose do

  let :params do
    [
      :name,
      :provider,
      :scale,
      :options,
<<<<<<< HEAD
<<<<<<< HEAD
=======
      :up_args,
>>>>>>> c887bd06d1850eff2505a6dc00584284155634ad
=======
      :up_args,
>>>>>>> 5b05f9928392d20140da52f72c42e34ca7b3c890
    ]
  end

  let :properties do
    [
      :ensure,
    ]
  end

  it 'should have expected properties' do
    properties.each do |property|
      expect(compose.properties.map(&:name)).to be_include(property)
    end
  end

  it 'should have expected parameters' do
    params.each do |param|
      expect(compose.parameters).to be_include(param)
    end
  end

	it 'should require options to be a string' do
		expect(compose).to require_string_for('options')
  end

<<<<<<< HEAD
<<<<<<< HEAD
=======
=======
>>>>>>> 5b05f9928392d20140da52f72c42e34ca7b3c890
	it 'should require up_args to be a string' do
		expect(compose).to require_string_for('up_args')
  end

<<<<<<< HEAD
>>>>>>> c887bd06d1850eff2505a6dc00584284155634ad
=======
>>>>>>> 5b05f9928392d20140da52f72c42e34ca7b3c890
	it 'should require scale to be a hash' do
		expect(compose).to require_hash_for('scale')
  end
end
