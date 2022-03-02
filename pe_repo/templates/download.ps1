# download.ps1 : This script is meant to help users that want to download the install.ps1 file from master in a secure way
# download.ps1 -Server <FQDN of Puppet Master>

Param(
  [Parameter(Mandatory = $false, ValueFromRemainingArguments = $true)]
  [String] $Server,
  # This value would be $null when no parameters are passed in; however, a PS2 bug causes foreach to iterate once
  # over $null, which is undesirable. Setting the default to an empty array gets around that PS2 bug.
  $arguments = @()
)

$port            = 8140
$puppet_conf_dir = Join-Path ([Environment]::GetFolderPath('CommonApplicationData')) 'Puppetlabs\puppet\etc'
$cert_path       = Join-Path $puppet_conf_dir 'ssl\certs\ca.pem'
$install_source  = "https://${Server}:${port}/packages/current/install.ps1"

$callback = {
  param(
      $sender,
      [System.Security.Cryptography.X509Certificates.X509Certificate]$certificate,
      [System.Security.Cryptography.X509Certificates.X509Chain]$chain,
      [System.Net.Security.SslPolicyErrors]$sslPolicyErrors
  )
  $CertificateType = [System.Security.Cryptography.X509Certificates.X509Certificate2]

  # Read the CA cert from file
  $CACert = $CertificateType::CreateFromCertFile($cert_path) -as $CertificateType

  # Add cert to collection of certificates that is searched by
  # the chaining engine when validating the certificate chain.
  $chain.ChainPolicy.ExtraStore.Add($CACert) | Out-Null

  # Compare the cert on disk to the cert from the server
  $chain.Build($certificate) | Out-Null

  # If the first status is UntrustedRoot, then it's a self signed cert
  # Anything else in this position means it failed for another reason
  return $chain.ChainStatus[0].Status -eq [System.Security.Cryptography.X509Certificates.X509ChainStatusFlags]::UntrustedRoot
}

function DownloadScript {
  Write-Verbose "Downloading the install script for Puppet Enterprise\"
  $webclient = New-Object system.net.webclient

  # If TLS1.2 is not available, use old versions
  tls1  = [Net.SecurityProtocolType]::Tls
  tls11 = [Net.SecurityProtocolType]::Tls11
  tls12 = [Net.SecurityProtocolType]::Tls12
  [System.Net.ServicePointManager]::SecurityProtocol = $tls1 -bor $tls11 -bor $tls12

  # Pass in a function to validate the cert. {$true} means validate any cert.
  [System.Net.ServicePointManager]::ServerCertificateValidationCallback = $callback

  try {
    $webclient.DownloadFile($install_source, (Join-Path ((Resolve-Path .\).Path) 'install.ps1'))
  }
  catch [System.Net.WebException] {
    # If we can't find the msi, then we may not be configured correctly
    if($_.Exception.StatusCode -eq 404) {
        Throw "Failed to download the Puppet Agent installer: $install_source. Does the Puppet Master have the $pe_repo_class class applied to it?"
    }

    # Throw all other WebExceptions in case the cert did not validate properly
    Throw $_
  }
}

if((Test-Path $cert_path)) {
    DownloadScript
} else {
    Throw "$cert_path does not exist. Please copy /etc/puppetlabs/puppet/ssl/certs/ca.pem from your Puppet Master."
}
