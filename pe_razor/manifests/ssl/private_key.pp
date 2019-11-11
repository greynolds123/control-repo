# Type for generating a simple private key
# This is only meant to be used within the
# pe_razor module.
define pe_razor::ssl::private_key(
  $path = $title,
  $pk8_path = undef
){
  # Key permissions must be 0600
  File {
    ensure =>  file,
    mode   => '0600',
  }

  $generated_key_file_title = "ssl private key ${title}"
  pe_razor::generated_file { $generated_key_file_title :
    file_path => $path,
    command   => "openssl genrsa -out ${path} 1024"
  }

  if $pk8_path {
    pe_razor::generated_file { "ssl pk8 key ${title}":
      file_path => $pk8_path,
      command   => "openssl pkcs8 -topk8 -nocrypt -inform PEM -outform DER -in ${path} -out ${pk8_path}",
      require   =>  Pe_razor::Generated_file[$generated_key_file_title],
    }
  }
}
