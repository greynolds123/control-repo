<<<<<<< HEAD
class create_multiple_ini_settings {

$defaults = { 'path' => '/tmp/foo.ini' }
$example = {
  'section1' => {
    'setting1'  => 'value1',
    'settings2' => {
      'ensure' => 'absent'
    }
  }
}
create_ini_settings($example, $defaults)

=======
# Manifest creating multiple ini_settings
class create_multiple_ini_settings {
  if $facts['osfamily'] == 'windows' {
    $defaults = { 'path' => 'C:/tmp/foo.ini' }
  } else {
    $defaults = { 'path' => '/tmp/foo.ini' }
  }

  $example = {
    'section1' => {
      'setting1'  => 'value1',
      'settings2' => {
        'ensure' => 'absent'
      }
    }
  }

  create_ini_settings($example, $defaults)
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
}

