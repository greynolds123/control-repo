Puppet::Type.newtype(:docker_compose) do
  @doc = 'A type representing a Docker Compose file'

  ensurable

<<<<<<< HEAD
<<<<<<< HEAD
=======
=======
>>>>>>> 5b05f9928392d20140da52f72c42e34ca7b3c890
  def refresh
      provider.restart
  end

<<<<<<< HEAD
>>>>>>> c887bd06d1850eff2505a6dc00584284155634ad
=======
>>>>>>> 5b05f9928392d20140da52f72c42e34ca7b3c890
  newparam(:name) do
    desc 'Docker compose file path.'
  end

  newparam(:scale) do
    desc 'A hash of compose services and number of containers.'
 		validate do |value|
      fail 'scale should be a Hash' unless value.is_a? Hash
			unless value.all? { |k,v| k.is_a? String }
        fail 'The name of the compose service in scale should be a String'
			end
			unless value.all? { |k,v| v.is_a? Integer }
        fail 'The number of containers in scale should be an Integer'
			end
		end
   end

	newparam(:options) do
    desc 'Additional options to be passed directly to docker-compose.'
		validate do |value|
      fail 'options should be a String' unless value.is_a? String
		end
	end

<<<<<<< HEAD
<<<<<<< HEAD
=======
=======
>>>>>>> 5b05f9928392d20140da52f72c42e34ca7b3c890
	newparam(:up_args) do
    desc 'Arguments to be passed directly to docker-compose up.'
		validate do |value|
      fail 'up_args should be a String' unless value.is_a? String
		end
	end

<<<<<<< HEAD
>>>>>>> c887bd06d1850eff2505a6dc00584284155634ad
=======
>>>>>>> 5b05f9928392d20140da52f72c42e34ca7b3c890
  autorequire(:file) do
    self[:name]
  end
end
