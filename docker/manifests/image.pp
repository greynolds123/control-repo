# Definition: docker::image
#
# This class installs or removes docker images.
#
# Requires docker version >=1.3.1
#
# Parameters:
# Option parameters:
# ensure => "latest" - pull a docker image
# ensure => "0.1.1" - tag version docker image
# ensure => "absent" - remove docker image
# tag => '0.1.1' - pull/remove a specific tag for the repo default is 'latest'
# image => 'myrepo.jgreat.me:port/myimage'
#
# Requires:
# - docker class
#
# Sample Usage:
#    require docker
#
#    docker::image { 'ubuntu':
#      tag => '14.04'
#    }
#
define docker::image (
    $ensure = 'latest',
    $tag = undef,
    $image = $title,
) {
  validate_string($ensure)
  validate_string($tag)
  validate_string($image)

  if (!$tag) {
    $image_tag = $ensure
  } else {
    $image_tag = $tag
  }

  # if ensure == absent and tag not defined, tag = latest
  if (($ensure == 'absent') and ($image_tag == 'absent')) {
    $image_tag = 'latest'
  }

  #Defaults for types
  Exec {
    path => '/bin:/usr/bin',
  }

  if ($ensure == 'absent') {
    #remove images if they exist
    exec { "docker rmi ${image}:${image_tag}":
      onlyif => "docker images -q ${image} | awk '{print \$2}' | grep ${image_tag}",
    }
  } else {
    exec { "docker pull ${image}:${image_tag}":
      unless => "docker images ${image} | awk '{print \$2}' | grep ${image_tag}",
    }
  }
}
